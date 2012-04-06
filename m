From: Sha Zhengju <handai.szj@gmail.com>
Subject: Re: [PATCH] memcg: revise the position of threshold index while unregistering
 event
Date: Fri, 06 Apr 2012 11:59:49 +0800
Message-ID: <4F7E6A35.10901@gmail.com>
References: <1331035943-7456-1-git-send-email-handai.szj@taobao.com>	<20120405163530.a1a9c9f9.akpm@linux-foundation.org> <20120405163758.b2ef6c45.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=sFIVoe9mx0WFeuDHCln3GQBCKiYM/DkmtzkBp8AmMao=;
        b=US7p7MqinnN20pCrJ7Nt5ecPNNtFivjcC0tAVzdD2wc1nX3xsUgydP8GKc1Po2M2Ly
         /ExLZQZ23WTH913+fbkz6DVAmdO0LjrDNakdYWETWwlwZ6ml9sEFBtoDBcbDYRgbYn1H
         7fNnbmdmH3PU2KcN57AoJQ+4GDEK53Gad1BqAF2+rZs11AkaQNZRRoqfbrTHl81CLiGZ
         ZjZHMlaAG/1vfBCTdE04NH7aLfCgXgEuTjH2ADoz8KSrUG57XcjvpEFoU1SbjyEuyQtP
         4eqUt/soPHtR0muI1Wb1pdCOh9RQVV8RMD1cSTPfpGjsYU+O5dLHnOCDvSMTGT16OeZq
         UXtQ==
In-Reply-To: <20120405163758.b2ef6c45.akpm@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, Sha Zhengju <handai.szj@taobao.com>

On 04/06/2012 07:37 AM, Andrew Morton wrote:
> On Thu, 5 Apr 2012 16:35:30 -0700
> Andrew Morton<akpm@linux-foundation.org>  wrote:
>
>> On Tue,  6 Mar 2012 20:12:23 +0800
>> Sha Zhengju<handai.szj@gmail.com>  wrote:
>>
>>> From: Sha Zhengju<handai.szj@taobao.com>
>>>
>>> Index current_threshold should point to threshold just below or equal to usage.
>>> See below:
>>> http://www.spinics.net/lists/cgroups/msg00844.html
>> I have a bad feeling that I looked at a version of this patch
>> yesterday, but I can't find it.
> Found it!  Below.
>
> I think we might as well fold "memcg: revise the position of threshold
> index while unregistering event" into the below "memcg: make threshold
> index in the right position" as a single patch?
>

Yeah, actually I've already sent a folded one before(maybe I should
mark it as V2):
http://www.spinics.net/lists/cgroups/msg01133.html

Thanks,
Sha


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
