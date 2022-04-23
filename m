From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 2/5] cgroup: Account for memory_recursiveprot in
 test_memcg_low()
Date: Sat, 23 Apr 2022 04:33:38 -0700
Message-ID: <20220423113338.yu6inrn2w5zmm3j6@dev0025.ash9.facebook.com>
References: <20220422155728.3055914-1-void@manifault.com>
 <20220422155728.3055914-3-void@manifault.com>
 <YmM0+/P0ro9pPzMf@carbon>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YmM0+/P0ro9pPzMf@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Apr 22, 2022 at 04:06:35PM -0700, Roman Gushchin wrote:
> Hopefully no one has a mountpoint with the memory_recursiveprot name :)

Heh, good point. I considered adding another root-level cgroup.features
file to match the features specified in /sys/kernel/cgroup/features, but
ultimately decided it wasn't warranted given that it just duplicates the
information in /proc/mounts.
