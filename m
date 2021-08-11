From: Qian Cai <quic_qiancai-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Subject: Re: move the bdi from the request_queue to the gendisk
Date: Tue, 10 Aug 2021 22:28:12 -0400
Message-ID: <4e108ea6-b1dd-510e-afc4-757eae697dab@quicinc.com>
References: <20210809141744.1203023-1-hch@lst.de>
 <e5e19d15-7efd-31f4-941a-a5eb2f94b898@quicinc.com>
 <20210810200256.GA30809@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1628648895; x=1660184895;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=mqrHT7lSpTYubUb4Uun7g5pFgQ69qr5SKKRD11vsmq0=;
  b=cdpMn0NbdlMX8mp1KU9fWzZ5lmzHKsv6m0vp7L4C5DvWtjqynyG0V/sG
   6qauRtKuziRD9TssNytxIXmZQWl+1hmYK5brB12d7T0bU/78u/RauZHLY
   wkBq5PPqpdwzgoycHsnVLpLHYBozSu7WN3saxAeRSPDqe6fkuP/+Uns3Q
   Q=;
In-Reply-To: <20210810200256.GA30809-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org



On 8/10/2021 4:02 PM, Christoph Hellwig wrote:
> On Tue, Aug 10, 2021 at 03:36:39PM -0400, Qian Cai wrote:
>>
>>
>> On 8/9/2021 10:17 AM, Christoph Hellwig wrote:
>>> Hi Jens,
>>>
>>> this series moves the pointer to the bdi from the request_queue
>>> to the bdi, better matching the life time rules of the different
>>> objects.
>>
>> Reverting this series fixed an use-after-free in bdev_evict_inode().
> 
> Please try the patch below as a band-aid.  Although the proper fix is
> that non-default bdi_writeback structures grab a reference to the bdi,
> as this was a landmine that might have already caused spurious issues
> before.

This works fine with a quick test.
