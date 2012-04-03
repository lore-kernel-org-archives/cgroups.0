From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] cgroup: cftype based file interface, take #2
Date: Tue, 3 Apr 2012 11:52:16 -0700
Message-ID: <20120403185216.GD27794@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1332368265-21586-1-git-send-email-tj@kernel.org>
 <20120330222936.GI28934@google.com>
 <4F7A6D13.4060704@parallels.com>
 <20120403184719.GB27794@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=YgzL4tJjJx1Etdxj0muHG5i3MA+xHAA87OFKlYNk8Bk=;
        b=G65CpwOA+AzSmQjILiXBYW16lHa8DYnJV05Aha7lqGTexajHQhWZXYp61Wb6DM7roV
         HbjkYCCLKm3KO2tNlY9PHUpiNj2j5do/oXseeCCzdkzbuPMZsqbEGjjnQxWqraJT8DU0
         xxstxE+RqniY43aGiOif6QPUG+DvUNBPY3lxZRpUgdjOjxqbt2tmlgMQyuytZoIBgtJM
         n5FQlEjiSz1J0X9DkQ2paiRN7jZSQJLmkkVB1DuFBDhSW9j+hnb1To819ZJFB5UWj/0O
         8bUF8x7quIZ+fBI6CKrbsiA4JSzNgWVjCC7wIju2995M/wbhomzQ9hSB0ogzGC7Z6kEF
         EzJg==
Content-Disposition: inline
In-Reply-To: <20120403184719.GB27794-RcKxWJ4Cfj1J2suj2OqeGauc2jM2gXBXkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Tue, Apr 03, 2012 at 11:47:19AM -0700, Tejun Heo wrote:
> Hello, Glauber.
> 
> On Tue, Apr 03, 2012 at 07:22:59AM +0400, Glauber Costa wrote:
> > Do I need to send you a patch to remove memcg's populate on top of this ?
> 
> populate is already gone.  My memory is a bit fuzzy now.  Can you spot
> something broken / to be improved re. memcg cftypes in the current
> cgroup/for-3.5 branch?

Ugh... brainfart.  Please disregard the previous message.  Can you
please resend the patches on top of cgroup/for-3.5 and use Li's new
address - lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org ?

Thanks.

-- 
tejun
