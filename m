From: Marat Khalili <mkh@rqc.ru>
Subject: Re: cgroups and nice
Date: Wed, 30 Nov 2016 12:51:42 +0300
Message-ID: <15e1abaf-112d-965c-8fe8-be5e9f7995e5@rqc.ru>
References: <8e909b7a-ad0f-431c-4981-3cafe2690da1@rqc.ru>
 <CAPhKKr8FWR6sfJNp62Q6bDxR5dAYr5uLf1HqfcVNWpNGYTFoVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPhKKr8FWR6sfJNp62Q6bDxR5dAYr5uLf1HqfcVNWpNGYTFoVQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Dhaval Giani <dhaval.giani@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>
Cc: cgroups@vger.kernel.org

On 29/11/16 00:13, Dhaval Giani wrote:
> This is an old version of the kernel. Do you see the same behavior on
> a newer version of the kernel? (4.8 is the latest stable kernel)
Sadly, RedHat is not very keen on updating their kernels. I did a quick 
experiment on Ubuntu box with kernel 4.4, and indeed it does not behave 
this strange way. So I'll write this off as a long fixed kernel bug, 
stick to auto-renicing in cron, and look forward to upgrading this 
CentOS machine some day. Thank you very much for your help.

--

With Best Regards,
Marat Khalili

