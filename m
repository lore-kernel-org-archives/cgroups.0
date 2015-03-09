From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 2/2] cgroups: add a pids subsystem
Date: Sun, 8 Mar 2015 23:39:46 -0400
Message-ID: <20150309033946.GG13283@htj.duckdns.org>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <1425606357-6337-1-git-send-email-cyphar@cyphar.com>
 <1425606357-6337-3-git-send-email-cyphar@cyphar.com>
 <20150309033405.GE13283@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=91xeZh9wV0+cxXuD38EyazXTzxNLmJpOrp93BD4dQCo=;
        b=H+7F7DDL8E2J4gnlb1/l4dDpRFXPfcfhOUqo0Euhqq55BwjgKgdqAb7frlgBIBjo2m
         jovDLrYBXGiDm2BTZzMa1a+mlPxvx48sC8KevG6W8cK3tKcEuZwt0870RmXgAba2F4vI
         S645ygfZ1STQ+iQjb/Ixffob+Us9tO9x+QNKXg5KzHoi92HbEfcpdYd0AAw3ksZGyhzB
         RvDtkn+HJKWGqCWGhxTOPSsiiDhz2GMSVknru8f07D6MzoY2J7qRaCifR0vyIjLFD0vc
         3/LL2T+1TMQt4jxa/X871Yntqmq3ATais75lK6iXmomHXXjzTwr+GY/wAoHnVzXcy+c0
         4GCQ==
Content-Disposition: inline
In-Reply-To: <20150309033405.GE13283-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Mar 08, 2015 at 11:34:05PM -0400, Tejun Heo wrote:
> > +	for (p = pids; p; p = p->parent) {
> > +		long new;
> > +
> > +		new = atomic_long_add_return(num, &p->counter);
> > +
> > +		if (p->limit == PIDS_UNLIMITED)
> > +			continue;
> 
> Huh?  So, the counter stays out of sync if unlimited?  What happens
> when it gets set to something else later?

Oops, I misread the code, but why is PIDS_UNLIMITED a special case?
Just make it a number which always makes the condition true?

Thanks.

-- 
tejun
