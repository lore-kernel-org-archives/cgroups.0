From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroup: remove extra calls to find_existing_css_set
Date: Fri, 20 Jan 2012 21:52:45 -0800
Message-ID: <CAOS58YOZEcDrUEaZXBmrys32bnRTPN_n5mZeyYXgVH=-6swz8Q@mail.gmail.com>
References: <1325654312-32477-1-git-send-email-msb@chromium.org>
	<1325654312-32477-3-git-send-email-msb@chromium.org>
	<20120121000842.GB2908@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120121025712.GB4656@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=4700kTLTKPjZHIEH7l/8Ezk/GbKrDnZKPmnnREbwu5I=;
        b=QbFIoXjbdRJLjzDuZjs7bhqJZ0EnGtdUJ+70twCWYHwfQnkXy/esYk114xkmwNmGmH
         8wnVmJatJZDTaup5ZIpnHvoIV0V5+/nk/J8m8ft/5xQkIu8juPguljW2s6580KqafjeN
         js3Ml0VzA/VEfSTRtDuh6xfTo8Bjw2Hnvp6lY=
In-Reply-To: <20120121025712.GB4656-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>

Hello,

On Fri, Jan 20, 2012 at 6:57 PM, Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> If I break out of step 2 via the goto (out_put_css_set_refs), I only
> want to put back the refs I've gotten so far.

But isn't tc->cg NULL if that happens?  (ooh, the if statement should
be testing tc->cg, my bad).

Thanks.

-- 
tejun
