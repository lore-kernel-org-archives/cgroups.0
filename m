From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: memory.force_empty is deprecated
Date: Sat, 19 Nov 2016 09:08:45 +1100
Message-ID: <CAKTCnz=ywwA4gYmdSGSksxH0qYkLpXob5DwvWWZJ0_mvAVBWwA@mail.gmail.com>
References: <OF57AEC2D2.FA566D70-ON48258061.002C144F-48258061.002E2E50@notes.na.collabserv.com>
 <20161104152103.GC8825@cmpxchg.org> <5b03def0-2dc4-842f-0d0e-53cc2d94936f@gmail.com>
 <OF4C17DCE5.3A69F6D5-ON4825806F.00234EAD-4825806F.00238F1A@notes.na.collabserv.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=MuNtG0+iWs+MmRHgUSHKVYM+jsMtr9jzpRpF3b164NU=;
        b=bxkZe6fnkbpUPOLekHYGNHZdSVkH0pyU9ahQbPm3nDy7doti/zrC3IvjZE70CJaBqB
         SdOkHS/6HlBj0XbGvqY48tpomgfu1rqr4J/fl7gm9fO1Jw4n1GpT/KuBknoACZ2wOzPJ
         cxHMbPgbDnvA043JcJgM26dSHpRyhJbSBRuC00B7pl4w4Pbs5AmoyGAYU42spUlDnqq8
         I63IsdOgtqIWsLe81ntsUau+5INkyiLv5LiBmTPJmNcCnLgtN4GFyv2lVI7xapq7l9Ib
         ekKoXab3e7Z5BWy4zz+kK/VzU6OFSmddphcXlArBTuFmoH0HfdtCF4GF8grndIAhovdg
         S+9A==
In-Reply-To: <OF4C17DCE5.3A69F6D5-ON4825806F.00234EAD-4825806F.00238F1A@notes.na.collabserv.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhao Hui Ding <dingzhh@cn.ibm.com>
Cc: "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>, Tejun Heo <tj@kernel.org>

On Fri, Nov 18, 2016 at 5:28 PM, Zhao Hui Ding <dingzhh@cn.ibm.com> wrote:
> Thank you.
> Do you mean memory.force_empty won't be deprecated and removed?
>
> Regards,
> --Zhaohui

No I am not implying that. That is decided by the maintainers.

Balbir Singh.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
