From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET block/for-next] IO cost model based work-conserving
 porportional controller
Date: Mon, 2 Sep 2019 08:56:52 -0700
Message-ID: <20190902155652.GH2263813@devbig004.ftw2.facebook.com>
References: <20190614015620.1587672-1-tj@kernel.org>
 <20190614175642.GA657710@devbig004.ftw2.facebook.com>
 <5A63F937-F7B5-4D09-9DB4-C73D6F571D50@linaro.org>
 <B5E431F7-549D-4FC4-A098-D074DF9586A1@linaro.org>
 <20190820151903.GH2263813@devbig004.ftw2.facebook.com>
 <9EB760CE-0028-4766-AE9D-6E90028D8579@linaro.org>
 <20190831065358.GF2263813@devbig004.ftw2.facebook.com>
 <88C7DC68-680E-49BB-9699-509B9B0B12A0@linaro.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ExZmdHMEcHQFC7Ma718ILSpw2fAuwQcwKpYKAS2PKzU=;
        b=NBcl9afAeyIyBTtymn4baMsgwrbOW8VMDzEIyIBoQSV9u7cX7EYdGBRzis7ZX/ofpq
         Eiq5zWUgDS1gThudbRGxRuvdIUSdeecCrmUw079Af0u8M/E6FSRgmZHiOxsZjI5CBWG5
         xzSIJhkMt5d+lPpg9TlKK47Qatxcd6yQmdLH3uhmLr5L0t+3NMIx6cxkrVGeZt5TP/mr
         vka8smR3nHLaVPmLT0w4ERN8kHG9ccOolEdLvs33DjgmNHa4AuZJzswXawbOwoVCsPKO
         ccmuA9Kklssq36S2AsrmMchUiCxpSabHThI0e8Siu5IQ46aUHsDqRbCh4qQ+x/QRQ5jw
         DNBg==
Content-Disposition: inline
In-Reply-To: <88C7DC68-680E-49BB-9699-509B9B0B12A0@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>, newella@fb.com, clm@fb.com, Josef Bacik <josef@toxicpanda.com>, dennisz@fb.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, bpf@vger.kernel.org

On Mon, Sep 02, 2019 at 05:45:50PM +0200, Paolo Valente wrote:
> Thanks for this extra explanations.  It is a little bit difficult for
> me to understand how the min/max teaks for exactly, but you did give
> me the general idea.

It just limits how far high and low the IO issue rate, measured in
cost, can go.  ie. if max is at 200%, the controller won't issue more
than twice of what the cost model says 100% is.

> Are these results in line with your expectations?  If they are, then
> I'd like to extend benchmarks to more mixes of workloads.  Or should I
> try some other QoS configuration first?

They aren't.  Can you please include the content of io.cost.qos and
io.cost.model before each run?  Note that partial writes to subset of
parameters don't clear other parameters.

Thanks.

-- 
tejun
