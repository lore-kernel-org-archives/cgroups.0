From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] misc_cgroup: remove error log to avoid log flood
Date: Fri, 10 Sep 2021 17:36:09 +0200
Message-ID: <20210910153609.GC24156@blackbody.suse.cz>
References: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu@tencent.com>
 <86e89df640f2b4a65dd77bdbab8152fa8e8f5bf1.1631077837.git.brookxu@tencent.com>
 <20210909143720.GA14709@blackbody.suse.cz>
 <CAHVum0ffLr+MsF0O+yEWKcdpR0J0TQx6GdDxeZFZY7utZT8=KA@mail.gmail.com>
 <YTpY0G3+IJYmGbdd@blackbook>
 <478e986c-bc69-62b8-936e-5b075f9270b4@gmail.com>
 <20210910092310.GA18084@blackbody.suse.cz>
 <1679f995-5a6f-11b8-7870-54318db07d0d@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631288171; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZBZRN9N1d5pyu4AdCx2wOykUXfyS79SPRhnX7ttZWoI=;
        b=iyD4aQR13XtpyGuJ53I7aLFdhysvYSWSxVBZgnn7ZhwG3yVUitIv/qbfIUccgDvq7+i/13
        M8/VtCPWPMg6CAslB/UzZsWpp8LGEPSL8AmuhZWP0ytWUTXcyj5NMnybRWgCLZyiyIX+y8
        dHBUCVW0U6qmGCL5JxUEjKUpH+qJPvM=
Content-Disposition: inline
In-Reply-To: <1679f995-5a6f-11b8-7870-54318db07d0d-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "brookxu.cn" <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Sep 10, 2021 at 10:29:21PM +0800, "brookxu.cn" <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Through events and events.local, we can determine which node has
> insufficient resources. For example, when the ‘events’ is large, we traverse
> down and use events.local to determine which node has insufficient
> resources.

IIUC, this works in situations when the limits are set in decreasing
fashion (from root down) till very (controller) leaves. That's a valid
config and you're right that following 'max' events gets you to the
misbehaving/underprovisioned cgroup.

> 'fail' counter does not seem to provide more effective
> information in this regard. When 'fail' is big, it seems that we still need
> to use events and events.local to determine the node of insufficient
> resources.
> I am not very sure what details can we learn through 'fail' counter.

If there's a limit on certain level with otherwise unconstrained cgroup
structure below (a valid config too), the 'fail' counter would help
determining what the affected cgroup is. Does that make sense to you?

The log messages as implemented currently, aren't as useful as proposed
'fail' counter (they would need report 'cg' path, not 'i').

I see justification for 'fail' events as a replacement for the dropped
log messages. Although it's not a complete replacement due to longer
persistence of the log, illustrated e.g. with the short-lived containers
whose cgroups/fail counts are gone).


Michal
