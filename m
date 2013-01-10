From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: use new hashtable implementation
Date: Thu, 10 Jan 2013 12:13:12 -0800
Message-ID: <20130110201312.GN20454@htj.dyndns.org>
References: <50EE3A47.9030005@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=5ALYNBhsxQFVMZwbw4yjFirFtczeaJKLIY51uaK4+Qo=;
        b=fFY9Jwfde2cer6FCs5gPiO5SoHP0mlar3/JCMPHMYow2a46GDd2oxHOfh0KvyUuABj
         1ZweYW0BLINTrVVMnyJ0XW1lU0pAwSqGwfodt07XHb63GnrXtV6U1IrT4RWFWXvD2JrI
         jdTqsZOhBCEyKCSB9jVohQcMNNbSB9Cmv9EAe15/VdGQF8lnU+zvqRQxs7xnlbSBMIA3
         vio8bWHSOI1HfaW/p0Gd9E24rCTPYrAryqIhOb9G09J5pLikS8lPuiqiY5gO4rpHFCgI
         pSOfNBAQGckfz+0kJ1belzHPOKiZg6KIxckM8Qpey2hT2VCbX7Qus74TqLmvpKesmwm8
         d+gA==
Content-Disposition: inline
In-Reply-To: <50EE3A47.9030005-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jan 10, 2013 at 11:49:27AM +0800, Li Zefan wrote:
> Switch cgroup to use the new hashtable implementation. No functional changes.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.9.  Thanks!

-- 
tejun
