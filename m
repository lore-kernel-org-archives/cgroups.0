From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v1 3/3] cgroup: relax common ancestor restriction for
 direct descendants
Date: Thu, 21 Jul 2016 11:04:01 -0400
Message-ID: <20160721150401.GE22680@htj.duckdns.org>
References: <20160720155147.GG4574@htj.duckdns.org>
 <6e975d80-4077-fb8b-ec84-708e37c8e149@suse.de>
 <20160720230228.GA19588@mtj.duckdns.org>
 <982fcf3a-3685-9bd7-dd95-7bff255c9421@suse.de>
 <20160720231949.GB19588@mtj.duckdns.org>
 <379e5b13-29d4-ca75-1935-0a64f3db8d27@suse.de>
 <20160721143330.GA5751@mail.hallyn.com>
 <1469112709.2331.11.camel@HansenPartnership.com>
 <20160721145905.GC22680@htj.duckdns.org>
 <4bc13b20-9e8f-f43c-27aa-df5ec981762e@suse.de>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iqm14kekr1jfKxtkc+jYyPD3ZysQ1rU5VwUWbUbdAX4=;
        b=p8qKZwG+MJopqrrGgEoAuXBmxxjCc9VfQkGdJwEZvhUvVgHvLl2MT6y75iBCr+1JsQ
         ya6z+Cb0Zv2RqPk637vlRZ4wBREgWXTUYxCCb2kHMFogu8PNA0fDoydpzBkz/oHVRqal
         k5ZdaYmuDjPtjCfhOSsk8A+Ynue4+6X2EUpmUgEEqaHmwndSLK8yJ0XNvShkBjbN3ReK
         vjsJ1eyVyqEbzZKYAfibDpSKjl9sE9fX6sjncgs8kLxV9Hxo7wmT6h9r1Eg7+WiXG5IS
         +mgQ4OgQs1swGtMsJD2be6szvztl8Cm5J+6OZKIpjLcOEhntpx/6Pf2GRulFFy6EgBMj
         EVjA==
Content-Disposition: inline
In-Reply-To: <4bc13b20-9e8f-f43c-27aa-df5ec981762e@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <asarai@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Serge E. Hallyn" <serge@hallyn.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Aditya Kali <adityakali@google.com>, Chris Wilson <chris@chris-wilson.co.uk>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Christian Brauner <cbrauner@suse.de>, dev@opencontainers.org

Hello, Aleksa.

On Fri, Jul 22, 2016 at 01:07:13AM +1000, Aleksa Sarai wrote:
> > Coordinate in userspace.  Request whatever is managing the cgroup
> > hierarchy to set up delegation.  It's not like permission model is
> > fully contained in kernel on modern systems anyway.
> 
> My experience with certain systemdaemons' cgroup handling doesn't inspire
> confidence :/ (from the runC side, we've had nothing but issues). Also, how

Fix it then.  Working around bugs in userland isn't a justifiable
rationale for adding new kernel features.

> do you even boot into a cgroupv2 system with systemd (I started backporting
> patches to openSUSE, but it's still not booting)?

With devel branch, just passing in the unified hierarchy boot param
seems to work fine here.

Thanks.

-- 
tejun
