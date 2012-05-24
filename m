From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH] slab+slob: dup name string
Date: Thu, 24 May 2012 16:06:23 +0400
Message-ID: <4FBE243F.3080002@parallels.com>
References: <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com> <alpine.DEB.2.00.1205220855470.17600@router.home> <4FBBAE95.6080608@parallels.com> <alpine.DEB.2.00.1205221216050.17721@router.home> <alpine.DEB.2.00.1205221529340.18325@chino.kir.corp.google.com> <1337773595.3013.15.camel@dabdike.int.hansenpartnership.com> <4FBCD328.6060406@parallels.com> <1337775878.3013.16.camel@dabdike.int.hansenpartnership.com> <alpine.DEB.2.00.1205230947490.30940@router.home> <4FBCF951.3040105@parallels.com> <20120524001831.GQ25351@dastard>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20120524001831.GQ25351@dastard>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Lameter <cl@linux.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>

On 05/24/2012 04:18 AM, Dave Chinner wrote:
>> Of course reasoning about why it was added helps (so let's try to
>> >  determine that), but so far the only reasonably strong argument in
>> >  favor of keeping it was robustness.
> I'm pretty sure it was added because there are slab names
> constructed by snprintf on a stack buffer, so the name doesn't exist
> beyond the slab initialisation function call...
>
> Cheers,
>
> Dave.
If that was the reason, we'd be seeing slab failing miserably where slub 
succeeds, since slab keeps no copy.


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
