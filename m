From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Mon, 19 Sep 2016 22:30:15 +0530
Message-ID: <CAG53R5XZRtG4BeLv9wdLB4wW4iDLnEPHeoynaTPi_Sp6ht_3fA@mail.gmail.com>
References: <20160901084406.GA4115@lst.de> <CAG53R5Ws4BJKqeEYfEoEx5kuaXUmhDKcXfH4Vx=LTMK6tKMG0A@mail.gmail.com>
 <ae3adcc4-253e-f87c-6ff6-202c91599f48@mellanox.com> <20160910161442.GC29259@lst.de>
 <20160910170151.GA5230@obsidianresearch.com> <20160911133421.GA23384@lst.de>
 <20160911143522.GL6415@leon.nu> <20160911171409.GA13442@obsidianresearch.com>
 <20160911172445.GA25953@lst.de> <20160911175235.GB13442@obsidianresearch.com>
 <20160912050717.GE8812@leon.nu> <CAG53R5X4stfy5+Jmg+XReUJqt56Z-zABK+UEswHW1dXhH-9cNw@mail.gmail.com>
 <1474290618.6520.23.camel@intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=DECjMuO9b+QAHgp9HQAuQBVDU8Jjzg92NJJaBo/LRFc=;
        b=fkCk+UgVmOBkeVIOzmgD8rm2S36ibtZW8mofCjU1gwZOxU3Dklyz4rtnbQy3J7fDVr
         ul7nKOiPYYB0UpE823fTNO2lv8C5ad6e1dhrOgrFCXUdTA4+yFN/PjsNFLZwLPNPiUCb
         rZzi5idlRTgKw3WARu2Zakev2e5XaWFMLL2c49dJZ9lIE4+G6q6RfHrms8KAPKsnJ90W
         ucZadFF/7B8MomOqX2bCCrfh1zocnq4/uU56Rs+3vG0W8SUT/xy6vjSevFLhIgE6sZ5o
         1VEvAVFt2NYkteFuSOESDcbrImVlJRgXghUOvJOI4pV4YMw8I4jWz7K9PBnkB8Gz2r39
         S4Yw==
In-Reply-To: <1474290618.6520.23.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Dalessandro, Dennis" <dennis.dalessandro@intel.com>
Cc: "leon@kernel.org" <leon@kernel.org>, "lizefan@huawei.com" <lizefan@huawei.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "corbet@lwn.net" <corbet@lwn.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "ogerlitz@mellanox.com" <ogerlitz@mellanox.com>, "hch@lst.de" <hch@lst.de>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "haggaie@mellanox.com" <haggaie@mellanox.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "Hefty, Sean" <sean.hefty@intel.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "james.l.morris@oracle.com" <james.l.morris@oracle.com>, "tj@kernel.org" <tj@kernel.org>, "liranl@mellanox.com" <liranl@mellanox.com>

Hi Denny,

On Mon, Sep 19, 2016 at 6:40 PM, Dalessandro, Dennis
<dennis.dalessandro@intel.com> wrote:
> On Wed, 2016-09-14 at 12:36 +0530, Parav Pandit wrote:
>> Hi Dennis,
>>
>> Do you know how would HFI1 driver would work along with rdma cgroup?
>
> Keep in mind HFI1 driver has two "modes" of operation. We support
> verbs, and would surely fall in line with whatever cgroups do for IB
> core.
Thanks for the feedback.

> For our psm interface, not sure how cgroups would come into play.
> Psm is designed to expose the hw to user and avoid the kernel when
> possible adding more kernel control is sort of contrary to that.
>
Yes, PSM is currently out of RDMA cgroup and in future we can take a
look on how things shape as subsystem if it does.

> Now that being said, Christoph recently made mention of maybe having a
> drivers/psm [1]. I really haven't had a chance to think about the
> implications of that, but maybe it's worth considering, after all we
> have two implementations, qib and hfi1. So anyway I'm not sure we need
> to be too concerned about cgroups right now as far as psm side of
> things goes.
>
o.k.
