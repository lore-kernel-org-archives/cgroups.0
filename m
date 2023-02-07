From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 09/19] io_uring: convert to use vm_account
Date: Tue, 7 Feb 2023 07:28:56 -0700
Message-ID: <eff3cc48-7279-2fbf-fdbd-f35eff2124d0@kernel.dk>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
 <44e6ead48bc53789191b22b0e140aeb82459e75f.1675669136.git-series.apopple@nvidia.com>
 <52d41a7e-1407-e74f-9206-6dd583b7b6b5@kernel.dk> <87k00unusm.fsf@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <io-uring-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GVbHcngcrxb+EtKZ7t6pGqbRT5EixlZslzmjZrbJg0w=;
        b=aKxw9JI4eNRmyEHa8pZiz59fi5N4wmsEKjVGoh78GkaeojSICmHq3P/0QQJjtCGoWY
         tVUtigRisgv/MaRvcsGvEaqU5XmI7siMb3JEJnqmaq2u6k0l1sDvsFB15Cb3uF8PyZnT
         /lp77ze+OK18ZTdBsQRqjUyC9LLE2R/xvF10LbmVqHfJv+TZlYTm7yhVjWnSnaQ84Pyk
         dP7pEXBu+ifEiQwpYfRYaQau+ZxgsvtXeyCfxTRkBkXPmZVSeu9YejJ+1MaIfZBocaeo
         Nlz2geKB6sc8dNPfmPhlRaSX7xgjR7f/h34Q41hurGXg2yT6yNMdJQIYKFDQOqi2K+We
         zc4g==
Content-Language: en-US
In-Reply-To: <87k00unusm.fsf@nvidia.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com, tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch, "Daniel P . Berrange" <berrange@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org

On 2/6/23 6:03?PM, Alistair Popple wrote:
> 
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 2/6/23 12:47?AM, Alistair Popple wrote:
>>> Convert io_uring to use vm_account instead of directly charging pages
>>> against the user/mm. Rather than charge pages to both user->locked_vm
>>> and mm->pinned_vm this will only charge pages to user->locked_vm.
>>
>> Not sure how we're supposed to review this, when you just send us 9/19
>> and vm_account_release() is supposedly an earlier patch in this series.
>>
>> Either CC the whole series, or at least the cover letter, core parts,
>> and the per-subsystem parts.
> 
> Ok, thanks. Will be sure to add everyone to the cover letter and patch
> 01 when I send the next version.
> 
> For reference the cover letter is here:
> 
> https://lore.kernel.org/linux-mm/cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com/
> 
> And the core patch that introduces vm_account is here:
> 
> https://lore.kernel.org/linux-mm/e80b61561f97296a6c08faeebe281cb949333d1d.1675669136.git-series.apopple@nvidia.com/
> 
> No problem if you want to wait for the resend/next version before
> taking another look though.

Thanks, that helps. Like listed in the cover letter, I also have to
agree that this is badly named. It's way too generic, it needs to have a
name that tells you what it does. There's tons of accounting, you need
to be more specific.

Outside of that, we're now doubling the amount of memory associated with
tracking this. That isn't necessarily a showstopper, but it is not
ideal. I didn't take a look at the other conversions (again, because
they were not sent to me), but seems like the task_struct and flags
could just be passed in as they may very well be known to many/most
callers?

-- 
Jens Axboe

