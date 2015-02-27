From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Fri, 27 Feb 2015 12:15:51 -0500
Message-ID: <20150227171551.GL3964@htj.duckdns.org>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <20150227114940.GB3964@htj.duckdns.org>
 <54F09E62.8000007@gmail.com>
 <CAO_RewbeTbMuqVG5wsui_gHwrdgqjF0KLk6yr5a3bb76VOkofg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jKggJNeINW7lJBGJxT5dWt3+uv08i3dLvDdI0WyMLjI=;
        b=zsvXLlZcd50+XH6D7hZFCrtAQKDIHn5o2OT7a4lPbTUAErmRXGK5dqdzwm6kxbY3Of
         7oPO+10cYPEG73/dMmQb9rYTxd5Iwu6s/7d8pj7Ppz8qADMDFi76YZDKzKZ1ep4iwgyW
         pt1kn1NiOv6Mvhls/e13inMXdsgJbxE9zmzchR3fM1uvKBwL+GT9ZkTAbHSogZBAN7Pa
         68ANr62HRAjNFAHfOr63c1nEV+8FFqeo+OqwUUvaSkJcyqAA80c4IGI1yvHP0CK/dWk1
         VAN5+0dw8Wu/nwuItOOjAxPygSI1u5/Fn3y74IPRaLUAC69k0FaaY4ViPXMDdt2NlH3N
         Ar7g==
Content-Disposition: inline
In-Reply-To: <CAO_RewbeTbMuqVG5wsui_gHwrdgqjF0KLk6yr5a3bb76VOkofg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Feb 27, 2015 at 09:12:45AM -0800, Tim Hockin wrote:
> I was told that the plan was to use kmemcg - but I was told that YEARS
> AGO.  In the mean time we all either do our own thing or we do nothing
> and suffer.

Wasn't it like a year ago?  Yeah, it's taking longer than everybody
hoped but seriously kmemcg reclaimer just got merged and also did the
new memcg interface which will tie kmemcg and memcg together.

> Something like this is long overdue, IMO, and is still more
> appropriate and obvious than kmemcg anyway.

Thanks for chiming in again but if you aren't bringing out anything
new to the table (I don't remember you doing that last time either),
I'm not sure why the decision would be different this time.

Thanks.

-- 
tejun
