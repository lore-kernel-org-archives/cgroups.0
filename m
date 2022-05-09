From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] percpu: improve percpu_alloc_percpu event trace
Date: Mon, 9 May 2022 17:06:05 -0400
Message-ID: <20220509170605.2eb7637e@gandalf.local.home>
References: <8d627f02-183f-c4e7-7c15-77b2b438536b@openvz.org>
        <202205070420.aAhuqpYk-lkp@intel.com>
        <e1c09bbb-2c58-a986-c704-1db538da905a@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e1c09bbb-2c58-a986-c704-1db538da905a-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Sat, 7 May 2022 17:51:16 +0300
Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:

> The same messages are generated for any other gfp_t argument in trace events.
> As far as I understand it is not a bug per se,
> but trace macros lacks __force attribute in 'gfp_t'-> 'unsigned long' casts.
> The same thing happens with mode_t and with some other places using __print_flags()
> for __bitwise marked types.

I'm curious as to where the gfp_t to unsigned long is happening in the
macros?

-- Steve
