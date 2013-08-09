From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET cgroup/for-3.12] cgroup: make cgroup_event specific to
 memcg
Date: Thu, 8 Aug 2013 21:00:32 -0400
Message-ID: <20130809010032.GA14792@mtj.dyndns.org>
References: <20130805162958.GF19631@mtj.dyndns.org>
 <20130805191641.GA24003@dhcp22.suse.cz>
 <20130805194431.GD23751@mtj.dyndns.org>
 <20130806155804.GC31138@dhcp22.suse.cz>
 <20130806161509.GB10779@mtj.dyndns.org>
 <20130807121836.GF8184@dhcp22.suse.cz>
 <20130807124321.GA27006@htj.dyndns.org>
 <20130807132613.GH8184@dhcp22.suse.cz>
 <20130807133645.GE27006@htj.dyndns.org>
 <5203081C.8050403@huawei.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=lvBessSqaHZXx/Jzk8Cr+dpchtaJO4Hrh2hXRjb6pqQ=;
        b=ZoMbVvN+onohOLF4btVVBgI6LiKq+7lQfZEUYd5HDEidvisJpV8kN5fDW4p3/S5ZSm
         /AfI9HprFfPNYl+YPEydKduMcNzaycYeGEgyqIXEVoMuDEfr7FdMkTZv27rE+iQwStjI
         hylfoeXrMxFDGXIzg92A93mGEqNiT6k9YjWiR3fZaxgouOIzAXdFVv5R6Gud24Oc19MG
         Z4rrzDoOKLyTPdmUjLAt8clRvmO0EgOT8Wq8noJU8QIPm1nPdLEJvdZKsy/yBTbLRqiY
         oWXN9pMAKjWVuOk0RZvYrE0YBhfV2U94Zj8bpST5iy2e42YnBuhOjma9u6GBeM03sVXf
         7hvA==
Content-Disposition: inline
In-Reply-To: <5203081C.8050403@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Michal Hocko <mhocko@suse.cz>, hannes@cmpxchg.org, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Hello, Li.

On Thu, Aug 08, 2013 at 10:53:16AM +0800, Li Zefan wrote:
> I would like to see this happen. I have a feeling that we're deprecating
> features a bit aggressively without providing alternatives.

I'd rework it prolly next week but this has to go one way or another.
There's no way we're implementing userland interface this complex in
cgroup proper.  It is a gross layering violation.  We don't implement
userland visible interface this complex in low level subsystems.  It's
wrong both in principle and leads to all sorts of problems in practice
like ending up worrying about userland abuses in memcg event source
implementation, which is utterly bonkers if you ask me.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
