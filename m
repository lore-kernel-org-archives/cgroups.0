From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 4/5] cgroup: Removing racy check in test_memcg_sock()
Date: Sat, 23 Apr 2022 04:50:30 -0700
Message-ID: <20220423115030.ee2gxwkwjzetzoby@dev0025.ash9.facebook.com>
References: <20220422155728.3055914-1-void@manifault.com>
 <20220422155728.3055914-5-void@manifault.com>
 <YmM/NCX9FwUY/GvB@carbon>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YmM/NCX9FwUY/GvB@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Apr 22, 2022 at 04:50:12PM -0700, Roman Gushchin wrote:
> On Fri, Apr 22, 2022 at 08:57:28AM -0700, David Vernet wrote:
> > test_memcg_sock() in the cgroup memcg tests, verifies expected memory
> > accounting for sockets. The test forks a process which functions as a TCP
> > server, and sends large buffers back and forth between itself (as the TCP
> > client) and the forked TCP server. While doing so, it verifies that
> > memory.current and memory.stat.sock look correct.
> > 
> > There is currently a check in tcp_client() which asserts memory.current >=
> > memory.stat.sock. This check is racy, as between memory.current and
> > memory.stat.sock being queried, a packet could come in which causes
> > mem_cgroup_charge_skmem() to be invoked. This could cause memory.stat.sock
> > to exceed memory.current. Reversing the order of querying doesn't address
> > the problem either, as memory may be reclaimed between the two calls.
> 
> But just curious, does it fix the flakiness (assuming there is no memory
> pressure)?

Yes, it does fix the flakiness. I saw it fail once or twice in my runs, but
to your point that was only in the presence of memory pressure, which could
make many of the tests in the file fail. Let me know if you'd prefer to put
the check back in, and instead reverse the order of querying memory.current
and memory.stat.sock.

> 
> > Instead, this patch just removes that assertion altogether, and instead
> > relies on the values_close() check that follows to validate the expected
> > accounting.
> 
> Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> 

Thanks!
