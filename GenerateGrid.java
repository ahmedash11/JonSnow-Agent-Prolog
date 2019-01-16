import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;


public class GenerateGrid {
	public int n;
	public int m;
	public String[][] grid;
	String[] types = { "F", "WW", "O" };
	public String fileName = "Kb";

	public GenerateGrid(int N, int M) throws IOException {

		this.n = N;
		this.m = M;
		BufferedWriter br = new BufferedWriter(new FileWriter(this.fileName+".pl"));
		StringBuilder sb = new StringBuilder();

		this.grid = new String[this.n][this.m];
		sb.append("jon(location(" + (this.n - 1) + "," + (this.m - 1) + "), 0, s0).");
		sb.append("\n");
		this.grid[this.n - 1][this.m - 1] = this.types[(int) (Math.random() * 3)];
		this.grid[this.n - 1][this.m - 1] = "JS";
		while (true) {
			int x = (int) (Math.random() * 3);
			int y = (int) (Math.random() * 3);
			if (x != 2 && y != 2) {
				this.grid[x][y] = this.types[(int) (Math.random() * 3)];
				this.grid[x][y] = "DS";
				sb.append("dS(location(" + x + "," + y + ")).");
				sb.append("\n");
				break;
			}
		}
		for (int i = 0; i < this.grid.length; i++) {
			for (int j = 0; j < this.grid[i].length; j++) {
				if (this.grid[i][j] == null) {
					this.grid[i][j] = this.types[(int) (Math.random() * 3)];
					if (this.grid[i][j] == "WW") {
						sb.append("whiteWalkers(location(" + i + "," + j + ") , s0).");
						sb.append("\n");
					} else if (this.grid[i][j] == "O") {
						sb.append("obst(location(" + i + "," + j + ")).");
						sb.append("\n");
					}

				}
			}
		}
		for (int i = 0; i < this.grid.length; i++) {
			sb.append("rows(" + i + ").");
			sb.append("\n");
		}
		for (int j = 0; j < this.grid[0].length; j++) {
			sb.append("columns(" + j + ").");
			sb.append("\n");
		}
		sb.append("obst(location(10, 10)). %Dummy data to avoid errors");
		sb.append("\n");
		br.write(sb.toString());
		br.close();
		this.grid[n - 1][m - 1] = "Jon";
		System.out.println((this.GridtoString()));
	
	}
	
	public String GridtoString() {
		String count = "";
		for (int i = 0; i < this.grid.length; i++) {
			for (int j = 0; j < this.grid[i].length; j++) {
				if (this.grid[i][j] == "Free")
					count += this.grid[i][j] + "\t\t";
				else
					count += this.grid[i][j] + "\t";
			}
			count += "\n";
		}

		return count;
	}

	public static void main(String[] args) throws IOException {
        int n = 3; 
        int m = 3;
		GenerateGrid newGrid =  new GenerateGrid(n, m);
	}
}
