import std.random;
import std.stdio;

import lib;

void show_game(Game game)
{
  import std.conv;
  import colorize;

  auto fgcolors = [fg.init, fg.white, fg.black];
  auto bgcolors = [bg.init, bg.red, bg.blue];
  auto agent_fgcolors = [fg.black, fg.black, fg.black, fg.black];
  auto agent_bgcolors = [bg.light_red, bg.magenta, bg.cyan, bg.green];

  foreach (y; 0..game.h_size) {
    foreach (x; 0..game.w_size) {
      string formatstr = "%4d";
      string agentstr = "";

      foreach (i, agent; game.agents) {
        if (x == agent.x && y == agent.y) {
          agentstr = (cast(char)(0x41 + i)).to!string();
          agentstr = agentstr.color(agent_fgcolors[i], agent_bgcolors[i]);
          formatstr = "%3d";
          break;
        }
      }


      int team = game.owners[y][x].to!int;
      write("|");
      cwritef(agentstr);
      cwritef(formatstr.color(fgcolors[team], bgcolors[team]), game.panels[y][x]);
    }
    writeln("|");
  }
}

void main()
{
  Random rng = rndGen();
  Game game = new Game(10, 10);
  game.set_points(rng);
  game.set_agents(rng);

  auto status = game.get_status_json();
  writeln(status);
  Game newGame = Game.from_status_json(status);

  newGame.owners[5][5] = Team.A;
  newGame.owners[5][6] = Team.B;

  show_game(newGame);
}
