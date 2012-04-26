From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 2/2] decrement static keys on real destroy time
Date: Thu, 26 Apr 2012 15:13:24 -0700
Message-ID: <20120426221324.GE27486@google.com>
References: <1335475463-25167-1-git-send-email-glommer@parallels.com>
 <1335475463-25167-3-git-send-email-glommer@parallels.com>
 <20120426213916.GD27486@google.com>
 <4F99C50D.6070503@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=rSdNInx5+iH1j8THGKWXEZzyx7MqCPJaJgiXsmRYIiY=;
        b=CnWz3qRAzvSTg+8n7aWnthsDX4H8avMotyb0CNID/Vqpz7uGhesfQ3TaZPlgYfppiI
         TkMna6s4y8HrHar2710qgUYiV6fbOm50wT1QSYeRBtgGTqu2SPWxmDH5aUirevJ3O+Dq
         K1c37wd2A9LHi0mpih2tBbAvguMFf7OKuYR0Ipe6/G6vCF+5KnMks0kxMTQEFecmtLsm
         GykRM6MurtpUu79/yc4HviDs8UZrhEbV/+fUG1pPN+sMLFCaOIlcG9+AImxjUxhm/ptx
         iCTL2OAeeKLMo862snoJbINzvjSMgSfTochgVBv8PYBwYGI8LUeIQPQDbPMkbXN7GwBU
         qYvQ==
Content-Disposition: inline
In-Reply-To: <4F99C50D.6070503@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, netdev@vger.kernel.org, Li Zefan <lizefan@huawei.com>, kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org, devel@openvz.org

Hello, Glauber.

On Thu, Apr 26, 2012 at 06:58:37PM -0300, Glauber Costa wrote:
> At first I though that we could get rid of all this complication by
> calling stop machine from the static_branch API. This would all
> magically go away. I actually even tried it.
> 
> However, reading the code for other architectures (other than x86),
> I found that they usually rely on the fixed instruction size to just
> patch an instruction atomically and go home happy.
> 
> Using stop machine and the like would slow them down considerably.
> Not only slow down the static branch update (which is acceptable),
> but everybody else (which is horrible). It seemed to defeat the
> purpose of static branches a bit.
> 
> The other users of static branches seems to be fine coping with the
> fact that in cases with multiple-sites, they will spread in time.

No, what I mean is that why can't you do about the same mutexed
activated inside static_key API function instead of requiring every
user to worry about the function returning asynchronously.
ie. synchronize inside static_key API instead of in the callers.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
