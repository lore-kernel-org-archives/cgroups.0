From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: fix exit() vsrmdir() race
Date: Thu, 24 Jan 2013 10:36:36 -0800
Message-ID: <20130124183636.GM2373@mtj.dyndns.org>
References: <5100D810.5020406@huawei.com>
 <20130124181923.GK2373@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=Y9YpC7ZDx4RAzNiv55IUciGgBYQzUIeC0cpFUdpkPpE=;
        b=a1Sob5V3PEPRn92AhGxBray/B+5tbtVqT2GAxx0mRfFW8UoqLkzWSsnCrVASi3H7uR
         pydvK/rCEX03GDk/FhfbwfE16dMT+8pJ5CQDeUeDojl3VL9w4fjKnce47SsVOvmygz9W
         DW4venSQFDK7WwtX24wtIRgnntl9arvRrYmNBGHn65qr4hxWoAmCJ5WDCROtlltaRMI6
         +7gm8ZZRu3B7ErvyVRkTTi2qrgYbsjE//SR97jwy/x5wVywZkARl9z/+b1LtaEhKNGHz
         cvMduubOtdv3EOXdkQqk7P6hmbEJB8VZjeQzlAkv6VJ6R/FW1T6I8MrzEnJH5pz5CMLR
         apHg==
Content-Disposition: inline
In-Reply-To: <20130124181923.GK2373-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jan 24, 2013 at 10:19:23AM -0800, Tejun Heo wrote:
> * cgroup_release_agent() seems broken too.  It's accessing cgrp after
>   removing it from release_list.  Can you please fix it too?

Oh, we should be okay as we're holding cgroup_mutex there.  Please
forget about the above.

Thanks.

-- 
tejun
