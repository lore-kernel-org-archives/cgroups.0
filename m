From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET block/for-next] IO cost model based work-conserving
 porportional controller
Date: Thu, 5 Sep 2019 09:55:40 -0700
Message-ID: <20190905165540.GJ2263813@devbig004.ftw2.facebook.com>
References: <20190614015620.1587672-1-tj@kernel.org>
 <20190614175642.GA657710@devbig004.ftw2.facebook.com>
 <5A63F937-F7B5-4D09-9DB4-C73D6F571D50@linaro.org>
 <B5E431F7-549D-4FC4-A098-D074DF9586A1@linaro.org>
 <20190820151903.GH2263813@devbig004.ftw2.facebook.com>
 <9EB760CE-0028-4766-AE9D-6E90028D8579@linaro.org>
 <20190831065358.GF2263813@devbig004.ftw2.facebook.com>
 <88C7DC68-680E-49BB-9699-509B9B0B12A0@linaro.org>
 <20190902155652.GH2263813@devbig004.ftw2.facebook.com>
 <D9F6BC6D-FEB3-40CA-A33C-F501AE4434F0@linaro.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=U86ZblmgaF4eBV4iyqRJf/CbV9WbHkWYMeJ0zFkqIu0=;
        b=TyUOTJJGoo8GODrCt/6YB1x/8aj4n9IE8jT/v+K7tCsOLINcESeyD/Ij4NXtMIB6Sy
         17L6qDvWQyCyeC7XEmXxoOnrWrvCkDJaDG0IEmRd9h3bbbHGAAp7YN0Z5zIHZIZQLjXo
         e7R4fvWV6g6XW9aD+hLJiCg7Lmv5aeBV8tuo+o7VsPjG3fXt7UmiwBwDqQNJlFXWk3TH
         5zwtfxF6mzHV0xMeRObFu3TfF099rR2GJ8US0yfbmsALUGRng05iBs5g6jzYHGRvKk8h
         FRvrTCHS5oUC5grWyibA9V7qghdaMk9oAmt6exGDzNOXAJpBRPdCLJ0cj/yBZJkPaFfd
         sbuQ==
Content-Disposition: inline
In-Reply-To: <D9F6BC6D-FEB3-40CA-A33C-F501AE4434F0@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>, newella@fb.com, clm@fb.com, Josef Bacik <josef@toxicpanda.com>, dennisz@fb.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, bpf@vger.kernel.org

Hello, Paolo.

So, I'm currently verifying iocost in the FB fleet.  Around three
thousand machines running v5.2 (+ some backports) with btrfs on a
handful of different models of consumer grade SSDs.  I haven't seen
complete loss of control as you're reporting.  Given that you're
reporting the same thing on io.latency, which is deployed on multiple
orders of magnitude more machines at this point, it's likely that
there's something common affecting your test setup.  Can you please
describe your test configuration and if you aren't already try testing
on btrfs?

Thanks.

-- 
tejun
