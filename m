From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/5] device_cgroup: fix locking in devcgroup_destroy()
Date: Mon, 3 Dec 2012 09:29:19 -0800
Message-ID: <20121203172919.GG19802@htj.dyndns.org>
References: <20121127193501.255267751@napanee.usersys.redhat.com>
 <20121127193501.728193744@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=pGJJ53PIYH16r7ZE7qDhGkRsjRtDvbEsxg8lVSAGS+8=;
        b=BuyJacWdTu0HNRg3G4+hl07Y8LhP1DNU4eX7yFxJzyYV6myhLe0GJibogzB2KHdgqA
         g7Z5ZFVW5YGPkOHJCv1BukHkAPyBlZVT3gNv9ggQ1IWXR7/V+c0jpqoSzQ535E6tjMCJ
         gKywes0NkifaDduSBfgXIPkI9qGYxMYmiRty2o96FLKXNCkm0rO0Ns7BL4j9yPBDCl9p
         HbcA9KckuUmHyNFYIGOpo3VPrBGnEJFhAG/SaemacTefv6e1CMi0lgj3UHDuK1uuZTu6
         j67xaQebbcSNesF2XgHVfSWJxSx88toxLL1+vWR0psFVhUsWs3X7ka2nQZgIWJzRYUrB
         fQ2A==
Content-Disposition: inline
In-Reply-To: <20121127193501.728193744@napanee.usersys.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>, cgroups@vger.kernel.org

On Tue, Nov 27, 2012 at 02:35:02PM -0500, Aristeu Rozanski wrote:
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
