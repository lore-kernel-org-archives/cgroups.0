From: Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH v13 14/16] vmpressure: in-kernel notifications
Date: Tue, 10 Dec 2013 12:12:57 +0400
Message-ID: <CAA6-i6rTyBtiyp9ed6DMj+U_b29Rwu7By997391WoyVxZ3YaoQ@mail.gmail.com>
References: <cover.1386571280.git.vdavydov@parallels.com>
	<252512613b0823c84478428f5543d2140d1291a5.1386571280.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=vCU72QTkUmtcR1Rb9vqXpGzH3y1IjgJwnHKAy8DFRJg=;
        b=GG7k6xDB4+Hcjz2tNvyk3F9E63po6x3dXz73ySdBhFZvGgUgdkbsPmvWrM7HfAr3hL
         0hOYUbcDJiN6MmHv81fXOIGCmDn+YeyjX+l2woltIXBKkZ82AyWRapVbO84MFrYffrOX
         +KfD7FZryLm5ZT58w/QJBTQZ1xflIwJzx+D3MdWZEVVuzTsSpwzFOh2oO4XEI/T9540Z
         8se4n487Tly0+4bdf/51ZOOHGAtU0KSR2dVTemcN5rCs0nG/RtA+xSG9XstiqBfcYTSp
         6cfoLfVKv56Vtby/CJemjQ07uPEGaK06eJIItHjcRg7kOHhK1IngnMUl7lowGNvgJ2U9
         M34g==
In-Reply-To: <252512613b0823c84478428f5543d2140d1291a5.1386571280.git.vdavydov@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: dchinner@redhat.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, Glauber Costa <glommer@openvz.org>, John Stultz <john.stultz@linaro.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

On Mon, Dec 9, 2013 at 12:05 PM, Vladimir Davydov
<vdavydov@parallels.com> wrote:
> From: Glauber Costa <glommer@openvz.org>
>
> During the past weeks, it became clear to us that the shrinker interface

It has been more than a few weeks by now =)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
