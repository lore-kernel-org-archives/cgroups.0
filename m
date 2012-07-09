From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Remove populate() documentation
Date: Mon, 9 Jul 2012 09:56:43 -0700
Message-ID: <20120709165643.GA1341@google.com>
References: <1341842048-14831-1-git-send-email-wagi@monom.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=1Otfb69q22KvXhZjFo7ViQfBFOhaEOj8duQz/hgovMI=;
        b=NTPV5U9wLWFNi9keUTH5z3+S5rY0w1IY7xftkIZJahFyAYeFraSxrQHVRki8RkDjYv
         DIsI8YkORxBNnM2rieMoSQbceJwbbN8D8oGNbTw6MJR7RcqZ3VCK7XyHaMI1pQkogRY9
         bCPhW5yz7L+mPnoIaYrrfIwvybuYX42flhOfXWPCYSvWK9lj99v2tjDRQ6ZYBDm/8YVh
         q/hwfhoc9b5cuqh+TS1Yk7mKHNRxgFjo3JEYtRzHS50ah96G3yiKDkbyldZbrzQjIgbq
         AcWgTdiTPGff3UH4EwQd+z599hrXCqk7SZfRBbByEd0g2Yglf2FznSXuoDdlcDcbcBY6
         sKKg==
Content-Disposition: inline
In-Reply-To: <1341842048-14831-1-git-send-email-wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On Mon, Jul 09, 2012 at 03:54:08PM +0200, Daniel Wagner wrote:
> From: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
> 
> This function was removed by 86f82d561864e902c70282b6f17cf590c0f34691.
> 
> Signed-off-by: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
> Cc: Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>
> Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Applied to cgroup/for-3.6.  Thanks!

-- 
tejun
