From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET block/for-next] IO cost model based work-conserving
 porportional controller
Date: Tue, 20 Aug 2019 08:19:03 -0700
Message-ID: <20190820151903.GH2263813@devbig004.ftw2.facebook.com>
References: <20190614015620.1587672-1-tj@kernel.org>
 <20190614175642.GA657710@devbig004.ftw2.facebook.com>
 <5A63F937-F7B5-4D09-9DB4-C73D6F571D50@linaro.org>
 <B5E431F7-549D-4FC4-A098-D074DF9586A1@linaro.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=c+ytF9JRpx+c+jH7VEntcNHapqJkhUT6uddNW8eq0CI=;
        b=j/1N4ekm9zWh5OV8A5seiIkduZDfjViU9YztBjbBDi/ScXALSStzfFPCDm2ywBgFj8
         AORxFbVW4sevVDpQebSL2W1ZojiMi+XLadvgTE3WCgc7EXGi+LOyEqH8QbHkcuPB8M6w
         IUTsf8zPnnBepJEIZ/O4HkfQjDt4ZNMqlk3lL6TsEqpC208NnZkb26y6clD8vPNbUxpF
         nzYJe9/TAMcTTEx4+jtfLT5n3UfKgN64VgK23qGqtcjtUVCFIZP5TO7t2fS5zVa60L80
         1h+LaGlzWQF8Gzp8ZMe7GR4lpBYwpXxxGot+HkJHKIGWwXc7E45B5XlcOCUfhxLDy/5c
         DxWQ==
Content-Disposition: inline
In-Reply-To: <B5E431F7-549D-4FC4-A098-D074DF9586A1@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>, newella@fb.com, clm@fb.com, Josef Bacik <josef@toxicpanda.com>, dennisz@fb.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, bpf@vger.kernel.org

Hello, Paolo.

On Tue, Aug 20, 2019 at 05:04:25PM +0200, Paolo Valente wrote:
> and makes one fio instance generate I/O for each group.  The bandwidth
> reported above is that reported by the fio instance emulating the
> target client.
> 
> Am I missing something?

If you didn't configure QoS targets, the controller is using device
qdepth saturation as the sole guidance in determining whether the
device needs throttling.  Please try configuring the target latencies.
The bandwidth you see for single stream of rand ios should have direct
correlation with how the latency targets are configured.  The head
letter for the patchset has some examples.

Thanks.

-- 
tejun
