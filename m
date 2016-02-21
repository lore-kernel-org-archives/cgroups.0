From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv6 1/3] rdmacg: Added rdma cgroup controller
Date: Sun, 21 Feb 2016 20:45:05 +0530
Message-ID: <CAG53R5UQzgWX327MbNV0HVC3XusTQEBN+a-CSUGMyztdE7Tr4w@mail.gmail.com>
References: <1455966006-13774-1-git-send-email-pandit.parav@gmail.com>
	<1455966006-13774-2-git-send-email-pandit.parav@gmail.com>
	<20160221074301.GK30450@leon.nu>
	<CAG53R5XGJESb+_-FtjLsK+jHoEmbePLd==G2knBMOcrfdPm62Q@mail.gmail.com>
	<20160221134518.GM30450@leon.nu>
	<CAG53R5U53sDQAURaWVeYmhnQSe+ncj+KWHdpOwbnrhE+OLVnMw@mail.gmail.com>
	<20160221150932.GN30450@leon.nu>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=U5s844F49kTPLo/F0fGOvRbWc2QLEpzTOG2K4nLJ7c0=;
        b=07OyuZGuOzJxCU/G9ztoYb3gBPqioCHJiB14CljOBeM2V1ecM32b8PywQYFMUVaQKX
         YX6PdJ6AmQcTp0vhtBkseSBmXkL7sGnmfNTRfMqOX6MVBIhiMpQ4gWA50jg/9iTOzbIj
         DLMhpNZ+8W5TyTOnIUR4l8pfrOd63Jl9p1lu9eftB8vZ6YvpnuWhiQadYQ+cJkSM2Imf
         vi3eDIGNzkwGf8CL47dgE34R22ANxKgALjneKwMn9HFZBfkG8Xax6r+3uMlVB5BgNv3c
         8UJbqN7OlE9y/AxKYiW8pBGEMy7dHwwr2mw2b8oyX29GTaiCgzglTuibsuKI4egN4o5y
         6U5A==
In-Reply-To: <20160221150932.GN30450@leon.nu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: leon@leon.nu, Parav Pandit <pandit.parav@gmail.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Sun, Feb 21, 2016 at 8:39 PM, Leon Romanovsky <leon@leon.nu> wrote:
> On Sun, Feb 21, 2016 at 07:41:08PM +0530, Parav Pandit wrote:
>> CONFIG_CGROUP_RDMA
>>
>> On Sun, Feb 21, 2016 at 7:15 PM, Leon Romanovsky <leon@leon.nu> wrote:
>> > On Sun, Feb 21, 2016 at 05:03:05PM +0530, Parav Pandit wrote:
>> >> On Sun, Feb 21, 2016 at 1:13 PM, Leon Romanovsky <leon@leon.nu> wrote:
>> >> > On Sat, Feb 20, 2016 at 04:30:04PM +0530, Parav Pandit wrote:
>> >> > Can you place this ifdef before declaring struct rdma_cgroup?
>> >> Yes. I missed out this cleanup. Done locally now.
>> >
>> > Great, additional thing which spotted my attention was related to
>> > declaring and using the new cgroups functions. There are number of
>> > places where you protected the calls by specific ifdefs in the
>> > IB/core c-files and not in h-files as it is usually done.
>> >
>> ib_device_register_rdmacg, ib_device_unregister_rdmacg are the only
>> two functions called from IB/core as its tied to functionality.
>> They can also be implemented as NULL call when CONFIG_CGROUP_RDMA is undefined.
>> (Similar to ib_rdmacg_try_charge and others).
>> I didn't do because occurrence of call of register and unregister is
>> limited to single file and only twice compare to charge/uncharge
>> functions.
>> Either way is fine with me, I can make the changes which you
>> described. Let me know.
>
> Please do,
> IMHO, it is better to have one place which handles all relevant ifdefs
> and functions. IB/core doesn't need to know about cgroups implementation.
>
ok. Done. Thanks for the review. I will accumulate more comments from
Tejun and others before spinning v7.
