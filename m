From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] cgroup changes for v4.5-rc1
Date: Mon, 11 Jan 2016 23:32:49 -0500
Message-ID: <20160112043249.GL3660@htj.duckdns.org>
References: <20160111200607.GK1898@mtj.duckdns.org>
 <CA+55aFwhyPZaEaDod2jRtG6Yw_+uFqjLyr99xCtCWyidiXombw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ByJzalui0o8E+Quia3apBwa7ptbChmMouHk8ULYD/FE=;
        b=vn3m9fMW05XutpD0lrz5YbKhztv2crolaiw8kL2Y0v9g0C8OBo86IMAvUwpsJTkwoM
         LCR+HZbdonNMb3rYYzs/JAygObAeiZ6N0qtW0/e2o+2B6cqingd/NSIEN6Zj+PR6I5/1
         PD4lmZj4zidVvF2ybtDMEwsOOyB4M4od+Q1uc9zJ+U3orqB7FlkSQW6uDDZyOQ5cnOVs
         YBHGkLDlEfQG34M/vZATaXFJlX1MpwaHf/VzelXagiasKk74zGhF0PDoZqYqkP+8Y1V7
         CXc5NDF3Kk5yYqjW5RflxVtu/Ea+IHX8iSKz9TGoT2Mtz0HpiPefjVn81YHdYGULhJMA
         aaYg==
Content-Disposition: inline
In-Reply-To: <CA+55aFwhyPZaEaDod2jRtG6Yw_+uFqjLyr99xCtCWyidiXombw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Linus.

On Mon, Jan 11, 2016 at 07:20:12PM -0800, Linus Torvalds wrote:
> On Mon, Jan 11, 2016 at 12:06 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > cgroup changes for v4.5-rc1.
> 
> Hmm. Is it really called for to rename all the docs etc
> "cgroup-legacy", considering that it's the one that is actually used,
> and the new one isn't even ready yet?
> 
> That seems very questionable.

Hmmm... yeah, maybe that was too aggressive.  Renaming it to
cgroup-v1/ and cgroup-v2.txt.  Will send out the updated pull request
soon.

Thanks.

-- 
tejun
