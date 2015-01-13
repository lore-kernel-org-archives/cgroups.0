From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memcg: remove extra newlines from memcg oom kill log
Date: Tue, 13 Jan 2015 09:15:15 -0500
Message-ID: <20150113141515.GA8180@phnom.home.cmpxchg.org>
References: <1421131539-3211-1-git-send-email-gthelen@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1421131539-3211-1-git-send-email-gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jan 12, 2015 at 10:45:39PM -0800, Greg Thelen wrote:
> Commit e61734c55c24 ("cgroup: remove cgroup->name") added two extra
> newlines to memcg oom kill log messages.  This makes dmesg hard to read
> and parse.  The issue affects 3.15+.
> Example:
>   Task in /t                          <<< extra #1
>    killed as a result of limit of /t
>                                       <<< extra #2
>   memory: usage 102400kB, limit 102400kB, failcnt 274712
> 
> Remove the extra newlines from memcg oom kill messages, so the messages
> look like:
>   Task in /t killed as a result of limit of /t
>   memory: usage 102400kB, limit 102400kB, failcnt 240649
> 
> Fixes: e61734c55c24 ("cgroup: remove cgroup->name")
> Signed-off-by: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
