From: Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH 1/2] vmpressure: in-kernel notifications
Date: Thu, 25 Apr 2013 11:34:05 -0700
Message-ID: <xr93txmuwjc2.fsf@gthelen.mtv.corp.google.com>
References: <1366705329-9426-1-git-send-email-glommer@openvz.org>
	<1366705329-9426-2-git-send-email-glommer@openvz.org>
	<xr937gjrhg1f.fsf@gthelen.mtv.corp.google.com>
	<51790A73.3030805@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=x-received:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version:content-type;
        bh=+3nM3JnGm3/AenTa2o+y9yVI4kFrUjqKKfTXJKYga8M=;
        b=eE1Lal2bt7wfi4w4shvyf+cbnJJ0BpzWX+FE0zVqHUyYoHujXE02OwC29Ij3yrZ1yL
         JU4iD9/rOv5fe/63sNqdTaQMlseSB7TlMYeZZVWI2BKksTYkipp8u0oNkod+sxT1QLCu
         evddcRa5tsWSbTD3aPL7nIGrWxCaLjLWbQ5ikY4p7HA/IOC1hy/HZDAFjx8epENAnzTp
         Pn43ZuLBSPCkxK5XDg9C2CDcNRZ1yrQ9d2+hWVs4aezQMAJ4XS2j4wqn2qFC2/bR7cIQ
         a10FRe5TFZUJn0sagfLnOALdx26j28Aq5UY2QYbqEgWGS/Y3XMM9xLd5ZFhc/l899C0x
         E38A==
In-Reply-To: <51790A73.3030805@parallels.com> (Glauber Costa's message of
	"Thu, 25 Apr 2013 14:50:27 +0400")
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: Glauber Costa <glommer@openvz.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Anton Vorontsov <anton.vorontsov@linaro.org>, John Stultz <john.stultz@linaro.org>, Joonsoo Kim <js1304@gmail.com>, Michal Hocko <mhocko@suse.cz>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>

On Thu, Apr 25 2013, Glauber Costa wrote:

> On 04/24/2013 11:42 PM, Greg Thelen wrote:
>>> +	vmpr->notify_userspace = true;
>> Should notify_userspace get cleared sometime?  Seems like we might need
>> to clear or decrement notify_userspace in vmpressure_event() when
>> calling eventfd_signal().
>> 
> I am folding the attached patch and keeping the acks unless the ackers
> oppose.
>
> Greg, any other problem you spot here? Thanks for the review BTW.

Looks good to me.  Feel free to add my tag to the patch with
vmpressure.diff folded in.

Reviewed-by: Greg Thelen <gthelen@google.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
