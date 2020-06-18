From: Chris Down <chris@chrisdown.name>
Subject: Re: mm: mkfs.ext4 invoked oom-killer on i386 - pagecache_get_page
Date: Thu, 18 Jun 2020 13:37:43 +0100
Message-ID: <20200618123743.GA694719@chrisdown.name>
References: <20200521095515.GK6462@dhcp22.suse.cz>
 <20200521163450.GV6462@dhcp22.suse.cz>
 <CA+G9fYsdsgRmwLtSKJSzB1eWcUQ1z-_aaU+BNcQpker34XT6_w@mail.gmail.com>
 <20200617135758.GA548179@chrisdown.name>
 <20200617141155.GQ9499@dhcp22.suse.cz>
 <CA+G9fYu+FB1PE0AMmE-9MrHpayE9kChwTyc3zfM6V83uQ0zcQA@mail.gmail.com>
 <20200617160624.GS9499@dhcp22.suse.cz>
 <CA+G9fYtCXrVGVtRTwxiqgfFNDDf_H4aNH=VpWLhsV4n_mCTLGg@mail.gmail.com>
 <20200617210935.GA578452@chrisdown.name>
 <CALOAHbBp7Ytd-Hta9NH-_HJtVTAsR5Pw2RYrVScp7PPezCEv2w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OgZomFoj/7toYCBCKWRo7nq/kYdKAWeXt05LtEajY3k=;
        b=Vba3/YBp135F4zjZnb2RedWXF2lwu1lFFL34CLaNpxPjPTPlt0UR472eYi5S4YZ1Wx
         Z0rDK+6Hs9d3o0cUOdxwi2SS36Jq5bWlnav7DNmZNgJpcMQ+D8caGFIGg/ORh0SmmPxl
         k69/g/gWD8TgMCYkGiY2Wz/GRty0LMQ/SrbXk=
Content-Disposition: inline
In-Reply-To: <CALOAHbBp7Ytd-Hta9NH-_HJtVTAsR5Pw2RYrVScp7PPezCEv2w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, Michal Hocko <mhocko@kernel.org>, Anders Roxell <anders.roxell@linaro.org>, "Linux F2FS DEV, Mailing List" <linux-f2fs-devel@lists.sourceforge.net>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, open list <linux-kernel@vger.kernel.org>, Linux-Next Mailing List <linux-next@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Arnd Bergmann <arnd@arndb.de>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Chao Yu <chao@kernel.org>, Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>, Matthew Wilcox <willy@infradead.org>, Chao Yu <yuchao0@huawei.com>, lkft-

Yafang Shao writes:
>On Thu, Jun 18, 2020 at 5:09 AM Chris Down <chris@chrisdown.name> wrote:
>>
>> Naresh Kamboju writes:
>> >After this patch applied the reported issue got fixed.
>>
>> Great! Thank you Naresh and Michal for helping to get to the bottom of this :-)
>>
>> I'll send out a new version tomorrow with the fixes applied and both of you
>> credited in the changelog for the detection and fix.
>
>As we have already found that the usage around memory.{emin, elow} has
>many limitations, I think memory.{emin, elow} should be used for
>memcg-tree internally only, that means they can only be used to
>calculate the protection of a memcg in a specified memcg-tree but
>should not be exposed to other MM parts.

I agree that the current semantics are mentally taxing and we should generally 
avoid exposing the implementation details outside of memcg where possible. Do 
you have a suggested rework? :-)
