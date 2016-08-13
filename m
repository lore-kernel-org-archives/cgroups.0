From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH 5/5] net: add test for net cgroup
Date: Fri, 12 Aug 2016 21:38:27 -0700
Message-ID: <20160813043825.GC55856@ast-mbp.thefacebook.com>
References: <1470876798-4024-1-git-send-email-anaravaram@google.com>
 <1470876798-4024-6-git-send-email-anaravaram@google.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hbCaH64Vv6+BBxivhsY3cYgUwxbGAPELPxzUx5dtn8g=;
        b=nf4TV6l+mO0cHyjPnwnMUsgwM8UzXh7hR/2+n8Xz/LosrNujc5N0T6GV63M49C5euk
         V0hzzr4/bZmomVSW2PauyEAu14ooiJTLSgwHNNpiJ2OynfrOMh/lWQDiJO6wpnUewJVR
         dTEIdLWNbA95NKhR6FwF4Gp1pAPJanxEemSUtAX0AQxVx7fdrSAWinLdhlQR3ZmUR8wD
         cb+eGKYg2LmCCM3tqM1yktECOnFaDP+0OrOzujqWxW0tpgf/jdFvvrZCKc3UzRH+CRz3
         waNSz4X/gPIKTpPkA2VvzrrZfrlqV35nVNUFErNWiNyo6frKSHgtHPiHkkWC4CK+aLT/
         tzHw==
Content-Disposition: inline
In-Reply-To: <1470876798-4024-6-git-send-email-anaravaram@google.com>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anoop Naravaram <anaravaram@google.com>
Cc: corbet@lwn.net, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net, linux-doc@vger.kernel.org, cgroups@vger.kernel.org, netdev@vger.kernel.org, edumazet@google.com, maheshb@google.com, weiwan@google.com, tom@herbertland.com

On Wed, Aug 10, 2016 at 05:53:18PM -0700, Anoop Naravaram wrote:
> Created a file scripts/cgroup/net_cgroup_test.py that tests the
> functionality of the net cgroup as described in previous commit logs.
> 
> Signed-off-by: Anoop Naravaram <anaravaram@google.com>
> ---
>  scripts/cgroup/net_cgroup_test.py | 359 ++++++++++++++++++++++++++++++++++++++

thanks for the test. It's great to have one, but it is concerning that
the test doesn't cover all the knobs the previous patches introduce
which underlines the point of my concern for previous patches.

