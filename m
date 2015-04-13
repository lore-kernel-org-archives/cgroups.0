From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2] cpuset: Add knob to make allowed masks hotplug
 invariant on legacy hierarchy
Date: Mon, 13 Apr 2015 10:50:52 -0400
Message-ID: <20150413145052.GC2596@htj.duckdns.org>
References: <20150410141118.11284.36206.stgit@preeti.in.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=qRsPcRRxnuhB2F1EuGmWCvKWdbpMOBtupWIZiVwtTLM=;
        b=xWunQ0mXRnaTv/BaE1+xRjJxymO8MEZcBGzoYQ6z9BEN3YHaEcMdWSfrAurDjjUQYJ
         ruTe/CCT7XQyeXY5DPrt3Mb8xeFXcCP7p1ANIB/fiC7MJZX7CHUzJUZoNauBxooEKuB9
         m1HLP0q4ZqQe/ahCT8J0fnfHJVrd1aVnK2SAJMjN5L/Orj8OUYEUNvuXqpgai5/+SBm9
         vS1a7NSNmt7Oa7OuuJnJ3yKGSqWKix9k1wAdey52bx/5+bjF+nf/bE0UzVCNK4Qgtzwf
         PS4UGKOQ0+fgIxg2uJ9hwuIJeX6o61BkF7cDvm6biCyCL5vFVHFtkPf9sjdT0EWV1leX
         rFFw==
Content-Disposition: inline
In-Reply-To: <20150410141118.11284.36206.stgit-KrPcdFQQmm2yUtPGxGje5AC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, nacc-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org

On Fri, Apr 10, 2015 at 07:41:52PM +0530, Preeti U Murthy wrote:
> Moreover the default hierarchy keeps the allowed masks hotplug invariant
> too. So the patch is not bringing about a fundamental change in the
> design of cgroups.

This is gonna be a new behavior anyway and I don't follow why you just
can't use the default hierarchy (well, of course except for that it
isn't ready yet but no matter what we do this is gonna take another
devel cycle so what's the difference?).  It's not like the default
hierarchy requires invasive changes.  I'm not convinced this calls for
yet another operation mode.

Thanks.

-- 
tejun
