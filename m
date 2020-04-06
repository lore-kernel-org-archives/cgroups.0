From: Tejun Heo <tj@kernel.org>
Subject: Re: Deadlock due to "cpuset: Make cpuset hotplug synchronous"
Date: Mon, 6 Apr 2020 10:34:05 -0400
Message-ID: <20200406143405.GH162390@mtj.duckdns.org>
References: <F0388D99-84D7-453B-9B6B-EEFF0E7BE4CC@lca.pw>
 <20200325191922.GM162390@mtj.duckdns.org>
 <20200326101529.xh763j5frq2r7mqv@e107158-lin>
 <20200403145523.GC162390@mtj.duckdns.org>
 <20200406105522.c66p4vzzzylety5d@e107158-lin.cambridge.arm.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8+jcnJTXIga9mkqHp3/5JxbQM57y376bXrCDo/ExKrY=;
        b=dGSTYEP5uA6qHfprtplk07U7wkOAEHGJIx4v6hfun7FO8q6S6D4pwPBnwLsU3pP83Y
         JZRw7+elch1nmfQtGY+9kSnNbjXh6McBm/e0fx3RrW/Osv8pWY9B+UyxwbQMZVjKUIKn
         FCqsUYZN5mh4h5E4WJw0K3zdisDMMN8hRPTwSPFBkRhVz1oWIlVYDmfqolDvjEo5ppQa
         jm8M7Kv6g59A7GbX/bJu7CkDzV4nF7paMpVPLN1O0oR70Ama+MZqxv8mXPJcMGPVD41y
         TXGyslkyDXnz9ABZ99vOb6Byf+vqCpYWwyNK8YGoaWBzygjeJcgfmoth8ZeMTH4hY7a9
         6E9A==
Content-Disposition: inline
In-Reply-To: <20200406105522.c66p4vzzzylety5d@e107158-lin.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qais Yousef <qais.yousef@arm.com>
Cc: Qian Cai <cai@lca.pw>, Prateek Sood <prsood@codeaurora.org>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>

On Mon, Apr 06, 2020 at 11:55:23AM +0100, Qais Yousef wrote:
> What would be the right approach to get a fix in then? We have been skipping
> this test for a while and we'd like to enable it but this failure is a
> blocking issue.

Update the test so that it accounts for the async nature of the operation?

-- 
tejun
