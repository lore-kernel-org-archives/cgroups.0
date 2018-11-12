From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 00/12] unify the interface of the proportional-share
 policy in blkio/io
Date: Mon, 12 Nov 2018 08:48:35 -0700
Message-ID: <c665a05b-66fc-6b8a-fa73-1c76885053db@kernel.dk>
References: <20181112095632.69114-1-paolo.valente@linaro.org>
 <9e8adb3271680165d85994a225713391@natalenko.name>
 <E8A20452-A73C-4A31-B5EC-48EFB9937832@linaro.org>
 <e85cfae0-7743-8c51-c2c9-0855c26f868e@kernel.dk>
 <F0F86365-D4EC-43F0-AE13-CC8FA6CC3D97@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jUM1IU2p9/emIAUN1aY2J9DJMh5MBq8/2GVefKP4h7U=;
        b=Oj1cxLTchF6eMB4wM3JXOcnrCPu6crvk8ipP/n3PJnD/l1H6DF0W75XgaGEIKwsWW/
         N+MOV/vj8kcwOQ1XLWgvS0qF62qgNaLWz9ix7TPlNHO/tzDSGgYod7PaffWtdxBZgXVF
         OJdbWzEwiqqIL4I85u1N4s8+5z3pZVr7/eMWn//8fcrdM8zV3RQaLRD7X7Klp5ZzefVw
         F0M+AL+voHaYSSVtGH7+fhArrtXYpqM8xc5j6qjJpExcQTxSpgfCPgixNiV9rtmx829/
         pDvHjTeo9krDcl+M3GRjx9GvHGodd/grMzoSnI61ANFN8LGme97JmLbYltlFYRu8oKjY
         XS5Q==
In-Reply-To: <F0F86365-D4EC-43F0-AE13-CC8FA6CC3D97@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, Mark Brown <broonie@kernel.org>, 'Paolo Valente' via bfq-iosched <bfq-iosched@googlegroups.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, lennart@poettering.net

On 11/12/18 8:45 AM, Paolo Valente wrote:
> BTW, since this patch series is probably even more useful for older
> than for future kernels, might it make sense to also propose it for
> stable/longterm kernels (provided that such a possibility exists)?

That just not how things work, we don't put different things in
older/stable kernels, it's strictly backports of what we have in
current/newer kernels. Hence it appears to be a dead end right now.

-- 
Jens Axboe

