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

  writeln("Turn: ", game.turn);

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

  writeln("team1 score: ", game.get_score(Team.A));
  writeln("team2 score: ", game.get_score(Team.B));
}

void do_game(ref Game game)
{
  import std.string;
  import std.conv;

  auto names = ["A", "B", "C", "D"];
  Action[] actions = [];
  foreach (i; 0..4) {
    writeln("player ", names[i], ": action");
    ActionName action = ActionName.Invalid;
    while (action == ActionName.Invalid) {
      write("1: move, others: remove >>");
      auto s = readln().strip();
      if (s == "1") {
        action = ActionName.Move;
      }
      else if (s == "2") {
        action = ActionName.Remove;
      }
    }

    int direction = -1;

    while (direction == -1) {
      write("direction [1-9] >>");
      try {
        int d = readln().strip().to!int;
        if (1 <= d && d <= 9) {
          direction = d;
        }
      }
      catch (ConvException e) {
        continue;
      }
    }

    actions ~= new Action(action, direction.to!Direction);
  }
  game.do_actions(actions);

}

void main()
{
  Random rng = rndGen();
  Game game = new Game(10, 10);
  game.set_points(rng);
  game.set_agents(rng);

  show_game(game);
  do_game(game);
  show_game(game);
}
