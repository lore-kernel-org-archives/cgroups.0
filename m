From: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Subject: Re: CFQ idling kills I/O performance on ext4 with blkio cgroup
 controller
Date: Wed, 22 May 2019 03:01:24 -0700
Message-ID: <01d55216-5718-767a-e1e6-aadc67b632f4@csail.mit.edu>
References: <8d72fcf7-bbb4-2965-1a06-e9fc177a8938@csail.mit.edu>
 <1812E450-14EF-4D5A-8F31-668499E13652@linaro.org>
 <46c6a4be-f567-3621-2e16-0e341762b828@csail.mit.edu>
 <07D11833-8285-49C2-943D-E4C1D23E8859@linaro.org>
 <A0DFE635-EFEC-4670-AD70-5D813E170BEE@linaro.org>
 <5B6570A2-541A-4CF8-98E0-979EA6E3717D@linaro.org>
 <2CB39B34-21EE-4A95-A073-8633CF2D187C@linaro.org>
 <FC24E25F-4578-454D-AE2B-8D8D352478D8@linaro.org>
 <0e3fdf31-70d9-26eb-7b42-2795d4b03722@csail.mit.edu>
 <F5E29C98-6CC4-43B8-994D-0B5354EECBF3@linaro.org>
 <686D6469-9DE7-4738-B92A-002144C3E63E@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <686D6469-9DE7-4738-B92A-002144C3E63E@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paolo Valente <paolo.valente@linaro.org>
Cc: linux-fsdevel@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, linux-ext4@vger.kernel.org, cgroups@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, jmoyer@redhat.com, Theodore Ts'o <tytso@mit.edu>, amakhalov@vmware.com, anishs@vmware.com, srivatsab@vmware.com

On 5/22/19 2:09 AM, Paolo Valente wrote:
> 
> First, thank you very much for testing my patches, and, above all, for
> sharing those huge traces!
> 
> According to the your traces, the residual 20% lower throughput that you
> record is due to the fact that the BFQ injection mechanism takes a few
> hundredths of seconds to stabilize, at the beginning of the workload.
> During that setup time, the throughput is equal to the dreadful ~60-90 KB/s
> that you see without this new patch.  After that time, there
> seems to be no loss according to the trace.
> 
> The problem is that a loss lasting only a few hundredths of seconds is
> however not negligible for a write workload that lasts only 3-4
> seconds.  Could you please try writing a larger file?
> 

I tried running dd for longer (about 100 seconds), but still saw around
1.4 MB/s throughput with BFQ, and between 1.5 MB/s - 1.6 MB/s with
mq-deadline and noop. But I'm not too worried about that difference.

> In addition, I wanted to ask you whether you measured BFQ throughput
> with traces disabled.  This may make a difference.
> 

The above result (1.4 MB/s) was obtained with traces disabled.

> After trying writing a larger file, you can try with low_latency on.
> On my side, it causes results to become a little unstable across
> repetitions (which is expected).
> 
With low_latency on, I get between 60 KB/s - 100 KB/s.

Regards,
Srivatsa
VMware Photon OS
