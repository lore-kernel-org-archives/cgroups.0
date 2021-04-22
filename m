From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH v3 15/16] memcg: enable accounting for tty-related objects
Date: Thu, 22 Apr 2021 16:59:01 +0300
Message-ID: <6e697a1f-936d-5ffe-d29f-e4dcbe099799@virtuozzo.com>
References: <dddf6b29-debd-dcb5-62d0-74909d610edb@virtuozzo.com>
 <da450388-2fbc-1bb8-0839-b6480cb0eead@virtuozzo.com>
 <YIFcqcd4dCiNcILj@kroah.com> <YIFhuwlXKaAaY3IU@dhcp22.suse.cz>
 <YIFjI3zHVQr4BjHc@kroah.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=RJzqymK4KdLIflkHg7fNUFw31wIE7fLJRZ1fSy+vabc=; b=N8B30dAs7aOqNLVdf
        Pa0srpVl2C/DUZIitS8DKW0kYyfVEDKhbVoZUwnyMgTE6eqTAucI0+gS+PYci9Bt8ed2mRP6H7RDN
        mIzWS40A9nXNBXchcDS2WdywUiQLu4jFtZgs2aCnkUUhnDABY/ChQ338ZFkUxDGG4aWO56rQ9uzl8
        =;
In-Reply-To: <YIFjI3zHVQr4BjHc-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Jiri Slaby <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 4/22/21 2:50 PM, Greg Kroah-Hartman wrote:
> On Thu, Apr 22, 2021 at 01:44:59PM +0200, Michal Hocko wrote:
>> On Thu 22-04-21 13:23:21, Greg KH wrote:
>>> On Thu, Apr 22, 2021 at 01:37:53PM +0300, Vasily Averin wrote:
>>>> At each login the user forces the kernel to create a new terminal and
>>>> allocate up to ~1Kb memory for the tty-related structures.
>>>
>>> Does this tiny amount of memory actually matter?
>>
>> The primary question is whether an untrusted user can trigger an
>> unbounded amount of these allocations.
> 
> Can they?  They are not bounded by some other resource limit?

I'm not ready to provide usecase right now,
but on the other hand I do not see any related limits.
Let me take time out to dig this question.

Thank you,
	Vasily Averin
