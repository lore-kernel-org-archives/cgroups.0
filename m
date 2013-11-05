From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v2 1/3] percpu: add test module for various percpu
 operations
Date: Mon, 4 Nov 2013 16:09:18 -0800
Message-ID: <20131104160918.0c571b410cf165e9c4b4a502@linux-foundation.org>
References: <1382895017-19067-1-git-send-email-gthelen@google.com>
	<1382895017-19067-2-git-send-email-gthelen@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382895017-19067-2-git-send-email-gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Sun, 27 Oct 2013 10:30:15 -0700 Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> Tests various percpu operations.

Could you please take a look at the 32-bit build (this is i386):

lib/percpu_test.c: In function 'percpu_test_init':
lib/percpu_test.c:61: warning: integer constant is too large for 'long' type
lib/percpu_test.c:61: warning: integer constant is too large for 'long' type
lib/percpu_test.c:61: warning: integer constant is too large for 'long' type
lib/percpu_test.c:61: warning: integer constant is too large for 'long' type
lib/percpu_test.c:61: warning: integer constant is too large for 'long' type
lib/percpu_test.c:61: warning: integer constant is too large for 'long' type
lib/percpu_test.c:70: warning: integer constant is too large for 'long' type
lib/percpu_test.c:70: warning: integer constant is too large for 'long' type
lib/percpu_test.c:70: warning: integer constant is too large for 'long' type
lib/percpu_test.c:70: warning: integer constant is too large for 'long' type
lib/percpu_test.c:70: warning: integer constant is too large for 'long' type
lib/percpu_test.c:70: warning: integer constant is too large for 'long' type
lib/percpu_test.c:89: warning: integer constant is too large for 'long' type
lib/percpu_test.c:89: warning: integer constant is too large for 'long' type
lib/percpu_test.c:89: warning: integer constant is too large for 'long' type
lib/percpu_test.c:89: warning: integer constant is too large for 'long' type
lib/percpu_test.c:89: warning: integer constant is too large for 'long' type
lib/percpu_test.c:89: warning: integer constant is too large for 'long' type
lib/percpu_test.c:97: warning: integer constant is too large for 'long' type
lib/percpu_test.c:97: warning: integer constant is too large for 'long' type
lib/percpu_test.c:97: warning: integer constant is too large for 'long' type
lib/percpu_test.c:97: warning: integer constant is too large for 'long' type
lib/percpu_test.c:97: warning: integer constant is too large for 'long' type
lib/percpu_test.c:97: warning: integer constant is too large for 'long' type
lib/percpu_test.c:112: warning: integer constant is too large for 'long' type
lib/percpu_test.c:112: warning: integer constant is too large for 'long' type
lib/percpu_test.c:112: warning: integer constant is too large for 'long' type
lib/percpu_test.c:112: warning: integer constant is too large for 'long' type
lib/percpu_test.c:112: warning: integer constant is too large for 'long' type
lib/percpu_test.c:112: warning: integer constant is too large for 'long' type
