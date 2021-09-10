From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] misc_cgroup: remove error log to avoid log flood
Date: Fri, 10 Sep 2021 11:23:10 +0200
Message-ID: <20210910092310.GA18084@blackbody.suse.cz>
References: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu@tencent.com>
 <86e89df640f2b4a65dd77bdbab8152fa8e8f5bf1.1631077837.git.brookxu@tencent.com>
 <20210909143720.GA14709@blackbody.suse.cz>
 <CAHVum0ffLr+MsF0O+yEWKcdpR0J0TQx6GdDxeZFZY7utZT8=KA@mail.gmail.com>
 <YTpY0G3+IJYmGbdd@blackbook>
 <478e986c-bc69-62b8-936e-5b075f9270b4@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631265791; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AxyNsNXpcaoyxBKXxrL/D1l4dorTQq9F7tfJh7pzbIo=;
        b=kYAeMRNqrK2eHW8Bx7E+FBsRJN1XYHIzivgkxEiakryLSLrDsy6FvBAEzVgC5JpU8OEJvk
        Dq84PXD+wNaMFFz5gxhbkp1IRbzyvgMej5zXNqlwkZe9WVMgq5A3cVrlcMjZZOGpUwKaBf
        PbaPXIsyAiDDmUACoSK1CkrKeVeDndw=
Content-Disposition: inline
In-Reply-To: <478e986c-bc69-62b8-936e-5b075f9270b4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Sep 10, 2021 at 01:30:46PM +0800, brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I am a bit confused here. For misc_cgroup, we can only be rejected when the count
> touch Limit, but there may be other more reasons for other subsystems.

Sorry, I wasn't clear about that -- the failures I meant to be counted
here were only the ones caused by (an ancestor) limit. Maybe there's a
better naem for that.

> Therefore, when we are rejected, does it mean that we have touch
> Limit? If so, do we still need to distinguish between max and fail?
> (for misc_cgroup)

r
`- c1
   `- c2.max
       `- c3
          `- c4.max
	     `- task t
          `- c5

Assuming c2.max < c4.max, when a task t calls try_charge and it fails
because of c2.max, then the 'max' event is counted to c2 (telling that
the limit is perhaps low) and the 'fail' event is counted to c4 (telling
you where the troubles originated). That is my idea. Although in the
case of short-lived cgroups, you'd likely only get the hierarchically
aggregated 'fail' events from c3 or higher with lower (spatial)
precision.
What would be the type of information useful for your troubleshooting?

Cheers,
Michal
