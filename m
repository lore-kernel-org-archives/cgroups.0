From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC] blk-throttle: export io_serviced_recursive,
 io_service_bytes_recursive
Date: Thu, 18 Jan 2018 12:56:13 -0700
Message-ID: <7456ac3f-e7e4-e91d-ef09-83e7c46cb2bd@kernel.dk>
References: <20171211145621.GA2115@localhost.didichuxing.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YfN3GopeOkjq0Il0c4F3swr+Odke2M87Jt4Fb0NHz+A=;
        b=xJHg+i2LbnFDd+BrLE6YpO4HbTx3bKbkTybRaqzdECg3bVw/ZX506OxzarLwO1UURd
         NBGT0fZBxlIIq/j4NDvbOPjwwoVADGrCIVHCDGv+dp2mIKz+y2GRduBG7vzPbQOCjYXs
         9bWcBPVlCRNSF5zsIHkD29hGbrcTCa6Q2G8q78DLVKCI/LwIaA1JbeKdkEd3W0DB+H6h
         L+c+OMf74x9N/HSsomXH5MOFweNJfcXzgTBL7dLNnV9mdOgGSa2HLqToOimAPGhDAjN5
         9cVazOjHIYQdaMK8w+63eHanCb8pYb7KRmdHGapzrBg1+JKj8rU2sFq2GCL17fscZZLE
         44lw==
In-Reply-To: <20171211145621.GA2115@localhost.didichuxing.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, shli@kernel.org, lizefan@huawei.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org

On 12/11/17 7:56 AM, weiping zhang wrote:
> export these two interface for cgroup-v1.

Applied, thanks.

-- 
Jens Axboe

