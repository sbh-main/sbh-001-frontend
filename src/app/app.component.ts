import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';

/**
 * @todo #1:16m/DEV Testing PDD
 */
@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet],
  templateUrl: './app.component.html',
  styleUrl: './app.component.sass'
})
export class AppComponent {
  title = 'project';
}
