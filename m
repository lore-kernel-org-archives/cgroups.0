From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Sat, 28 Feb 2015 11:43:53 -0500
Message-ID: <20150228164353.GR3964@htj.duckdns.org>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <20150227114940.GB3964@htj.duckdns.org>
 <54F09E62.8000007@gmail.com>
 <20150227170640.GK3964@htj.duckdns.org>
 <54F0BC51.4050506@gmail.com>
 <CAOviyajSOY6kTiwTA+APf9VGT=Ui=0QQH6KUqwaxHB3ahuJk2g@mail.gmail.com>
 <20150228115926.GA1005@htj.duckdns.org>
 <CAAAKZws45c3PhFQMGrm_K+OZV+KOyGV9sXTakHcTfNP1kHxzOQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=kGSSa+nzEIfEeuKFyIMnp1fY2FsLzKbG0qeRmUe+jzg=;
        b=AfLI/HbpKjbTFaq600lLQ4e4MkycQMoRbx0lzamsWUjqSSu9jW8EJP87xNUqKaHRL2
         4vIrP0Wy08zcVzE4cpgYLdqaUpP1m8dR+0OteQMC7zJTlrH/tLT2j8oRnHMl8z6Qqv0T
         pMmRQNprjalUKovlwym08OzrfSLtzue/RZGU/wSDxyvYodNW4r2YjuMDs2o0tD7R/RXK
         pTkNDq7bA8VLVUBMmnSYNLmEjF13hgSSQbGBnNCycWlYzd6939ht+lTdgAfdC04auXTF
         Z1cjoNeNBF5hsx/9eBgtqB1esGKc570qdUHWssOzjbsJJfDNHSkzr/EBso0VkZgXIkww
         Hrgw==
Content-Disposition: inline
In-Reply-To: <CAAAKZws45c3PhFQMGrm_K+OZV+KOyGV9sXTakHcTfNP1kHxzOQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>
Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Tim.

On Sat, Feb 28, 2015 at 08:38:07AM -0800, Tim Hockin wrote:
> I know there is not much concern for legacy-system problems, but it is
> worth adding this case - there are systems that limit PIDs for other
> reasons, eg broken infrastructure that assumes PIDs fit in a short int,
> hypothetically.  Given such a system, PIDs become precious and limiting
> them per job is important.
>
> My main point being that there are less obvious considerations in play than
> just memory usage.

Sure, there are those cases but it'd be unwise to hinge long term
decisions on them.  It's hard to even argue 16bit pid in legacy code
as a significant contributing factor at this point.  At any rate, it
seems that pid is a global resource which needs to be provisioned for
reasonable isolation which is a good reason to consider controlling it
via cgroups.

Thanks.

-- 
tejun
