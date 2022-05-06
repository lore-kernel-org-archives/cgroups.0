From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] percpu: improve percpu_alloc_percpu event trace
Date: Fri, 6 May 2022 10:52:30 +0300
Message-ID: <2b388d09-940e-990f-1f8a-2fdaa9210fa0@openvz.org>
References: <8d627f02-183f-c4e7-7c15-77b2b438536b@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=LbwqLZPNjAVAGchFJpgdUXESVOy5RrVk4EawuoFFTlM=;
        b=GZn+Eatwi9msnEaiiuXKK3haDVt8cFLEFeWrtWgkIDrh/sFvPdajeBLE0LV8qTSKOy
         2dpUaZxHUW9ao+Tn/O+xNebjQBfxeeSoe5YgSeolObFLprDooWECch2w3ZxRr+BwubK3
         dm2zLgPdUo4gneJqSKKvrTkL/NtEir4+1p8bguVsn7xPvbt8JU33WbFzbYqx5nvCVY3R
         d5nM7ZsbuFaaGVcztnoDLOH2wFeaMTEs8U2kZ6/f+ZPktivu9km54F5Y3A+46fBmOFib
         PWtdR6uhF5bdavHFiBEv9ek8xuR8xmN+Az5yppLfeFbGOgK75q6RqwP3DnBoCbUCyfgV
         4N6w==
Content-Language: en-US
In-Reply-To: <8d627f02-183f-c4e7-7c15-77b2b438536b-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 5/6/22 07:46, Vasily Averin wrote:
> Added bytes_alloc and gfp_flags fields to the output of the
> percpu_alloc_percpu ftrace event. This is required to track
> memcg-accounted percpu allocations.

Perhaps it makes sense to add call_site too...
