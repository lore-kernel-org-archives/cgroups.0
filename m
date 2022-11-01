From: Jiri Slaby <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] block/blk-iocost (gcc13): cast enum members to int in
 prints
Date: Tue, 1 Nov 2022 06:46:56 +0100
Message-ID: <d833ad15-f458-d43d-cab7-de62ff54a939@kernel.org>
References: <20221031114520.10518-1-jirislaby@kernel.org>
 <Y1++fLJXkeZgtXR2@infradead.org> <Y2AMcSPAJpj6obSA@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <Y2AMcSPAJpj6obSA-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Martin Liska <mliska-AlSwsSmVLrQ@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 31. 10. 22, 18:57, Tejun Heo wrote:
> On Mon, Oct 31, 2022 at 05:24:28AM -0700, Christoph Hellwig wrote:
>> On Mon, Oct 31, 2022 at 12:45:20PM +0100, Jiri Slaby (SUSE) wrote:
>>> Cast the enum members to int when printing them.
>>>
>>> Alternatively, we can cast them to ulong (to silence gcc < 12) and use %lu.
>>> Alternatively, we can move VTIME_PER_SEC away from the enum.
>>
>> Yes, either split the enum or just use a define.  But casts are a big
>> code smell and should be avoided if there is a reasonable alternative.
> 
> enums are so much better for debugging and other instrumentation stuff. The
> only requirement for the enum types is that they're big enough to express
> all the members and we can use whatever printf format letter which matches
> the type in use. The problem here is that the compiler behavior is different
> depending on the compiler version, which kinda sucks.

Yes. The real problem is that using anything else then an INT_MIN <= x 
<= INT_MAX _constant_ in an enum is undefined in ANSI C < 2x (in 
particular, 1 << x is undefined too). gcc manual defines unsigned int on 
the top of that as defined too (so this holds for our -std=g*).

> I suppose the most reasonable thing to do here is just splitting them into
> separate enum definitions. Does anyone know how this behavior change came to
> be?

C2x which introduces un/signed long enums. See the bug I linked in the 
commit log:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=36113

The change is also turned on in < C2x on purpose. AIUI, unless there is 
too much breakage. So we'd need to sort it out in (rather distant) 
future anyway (when we come up to -std=g2x).

> Do we know whether clang is gonna be changed the same way?

In C2x, Likely. In < C2x, dunno what'd be the default.

thanks,
-- 
js
suse labs

