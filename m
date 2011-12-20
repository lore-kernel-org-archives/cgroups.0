From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/5 V3] cgroup: remove redundate get/put of old css_set
 from migrate
Date: Tue, 20 Dec 2011 15:46:02 -0800
Message-ID: <20111220234602.GP10752@google.com>
References: <1324422873-31001-1-git-send-email-msb@chromium.org>
 <1324422873-31001-2-git-send-email-msb@chromium.org>
 <20111220231823.GK10752@google.com>
 <20111220234131.GV13529@google.com>
 <20111220234259.GO10752@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=OatDH810zfx/cNP62ujqYeI7pPX7RLCV/1J/LQoOmX4=;
        b=uprcsZBpDczhzYMjYztDcm03CIelS0ejIcScdOoSiKHBEEX3XmIxezBGm3ta31oPiY
         r6/lIEJRMNRu2Pu7SC7ywKDJzRQlUTwz1nOZohrtXp1SeNO/RuT86E/iL0dnAkbmbSap
         pYgPB9hsgTegLoJw73W2mvRQNBDEDYaBTsDiw=
Content-Disposition: inline
In-Reply-To: <20111220234259.GO10752-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>

On Tue, Dec 20, 2011 at 03:42:59PM -0800, Tejun Heo wrote:
> > But I can stop using scissors if that is what you prefer.
> 
> Heh, that's cute.  If git-am is happy, I'm happy too.  Thanks for
> letting me know.

Hmm... on the second thought, it's not enabled by default and I
suspect git-quiltimport would cut it out.  Let's stick to below --- or
in the commit message.

Thank you.

-- 
tejun
