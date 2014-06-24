From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] mm/mempolicy: fix sleeping function called from invalid
 context
Date: Tue, 24 Jun 2014 16:58:32 -0400
Message-ID: <20140624205832.GB14909@htj.dyndns.org>
References: <53902A44.50005@cn.fujitsu.com>
 <20140605132339.ddf6df4a0cf5c14d17eb8691@linux-foundation.org>
 <539192F1.7050308@cn.fujitsu.com>
 <alpine.DEB.2.02.1406081539140.21744@chino.kir.corp.google.com>
 <539574F1.2060701@cn.fujitsu.com>
 <alpine.DEB.2.02.1406090209460.24247@chino.kir.corp.google.com>
 <53967465.7070908@huawei.com>
 <20140620210137.GA2059@mtj.dyndns.org>
 <53A8E23C.4050103@huawei.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=2Mb0Y9lpE85Osk0l4uXDe9jhLX7krpMJ0HL8Ssh2Z/M=;
        b=odK9+unMsS57ccWeyOLRv4moCRu6JxF1owJKNn3kq5C5m9gE0NcIpDCU3Ccid868pP
         SODCiP7kOusSEDvd6mgw3TAdENBYEygPbFD1T6AsDrzjnaSPgJdNIyw634+QBT50UszL
         IeMhKPxH+COd9NQnT2LG9aFtyAcFBQHRcQqxiJjpt+ghy4Li0Wgg0LX74s+ZmF0CTnBm
         HfXgyGV7bGb1oKxUk4fD+RxCq5scPk3FkP6YjJSiwoIgtAIiejgKsW1PaUqpmVgGU7bN
         90fYNERuLocnh2qK8nnjozcI5BmIg7EmGEIBx+fFLOHMMq/j2PPEthj9vEFMXIhpqkjf
         YV8w==
Content-Disposition: inline
In-Reply-To: <53A8E23C.4050103@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: David Rientjes <rientjes@google.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Cgroups <cgroups@vger.kernel.org>, stable@vger.kernel.org

Hello,

On Tue, Jun 24, 2014 at 10:28:12AM +0800, Li Zefan wrote:
> > I don't think the suggested patch breaks anything more than it was
> > broken before and we should probably apply it for the time being.  Li?
> 
> Yeah, we should apply Gu Zheng's patch any way.

Gu Zheng, can you please respin the patch with updated explanation on
the temporary nature of the change.  I'll apply it once Li acks it.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
