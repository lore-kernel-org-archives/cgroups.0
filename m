From: Anatoly Pugachev <matorola@gmail.com>
Subject: Re: [sparc64] kernel OOPS (was: [PATCH 4/5] block: move the bdi from
 the request_queue to the gendisk)
Date: Thu, 14 Oct 2021 23:27:50 +0300
Message-ID: <CADxRZqxgu_A=BMOPVCAUteLfLUWAmL_b-S8+TBW1j-eW5O6dwA@mail.gmail.com>
References: <20210809141744.1203023-1-hch@lst.de> <20210809141744.1203023-5-hch@lst.de>
 <20211014143123.GA22126@u164.east.ru> <20211014143243.GA25700@lst.de>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X/5NOuaTC7GdG1HuEPP9I36zK6ViujDRxabRQSupDHo=;
        b=mZSIsOvJHc61pRh6A/XJqJhCkjUDhzyZEDo0NiXq4EYG0pvrL6zmdtCQRc4MVmsnRu
         W4bA9WqUDspnIcnE1LObWeijQbP2Fl0/5uDdIQ4qT3nxE/+dCQbziFDKajSfkPbjAgNq
         IXnp9Qlrkvoc0bTXmxaJD/zWelOAZMHWoSqggSezx//cPL1hGkxfSNQyepSzibIqTrvm
         VddHdN8lvISRpJDGlimsVktN+y7WaTFkTqlHJbVFTTu76vkxvCwvL+FDp+TCJs7fijDW
         FNsAfXZsNMCAnyBhw/sxSuF5cmu3+WH911MqcwCx6X0wRCAPkya1XWVHvwxT6JEK/bNO
         J5sw==
In-Reply-To: <20211014143243.GA25700@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm <linux-mm@kvack.org>, Sparc kernel list <sparclinux@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>

On Thu, Oct 14, 2021 at 5:32 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Hi Anatoly,
>
> please try this patchset:
>
> https://lore.kernel.org/linux-block/CAHj4cs8tYY-ShH=QdrVirwXqX4Uze6ewZAGew_oRKLL_CCLNJg@mail.gmail.com/T/#m6591be7882bf30f3538a8baafbac1712f0763ebb

Christoph,

thanks. Tested (with 5.15.0-rc5 + patchset) and no-more hangs with the
test-suite. Thanks again.
