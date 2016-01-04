From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH net-next] net: Add l3mdev cgroup
Date: Mon, 4 Jan 2016 14:23:01 -0500
Message-ID: <20160104192301.GC3807@mtj.duckdns.org>
References: <1451925136-13327-1-git-send-email-dsa@cumulusnetworks.com>
 <20160104175836.GA11668@mtj.duckdns.org>
 <568ABFC3.3010803@cumulusnetworks.com>
 <20160104185936.GA3807@mtj.duckdns.org>
 <568AC534.1070308@cumulusnetworks.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=UaXBb4kNExCUHavGPfMBH8vbIFnTcWGPcV8bckuXuzw=;
        b=tTG6R4og2Mdbw0krNqCO3sMDlmeGTlssLbOcgUJCST49hmrSSa7iNMebOYD3y3UbnX
         uxkBNWp7XitLJZbk58amBfHmUTYMV94U8zgGFhr0t3z36SsY/WQPcg0JDBG5v60oyHEu
         AEilAo+JdfRQp0TsJqmmgV6PaVoyL82a7CWQ7HBQEt9dkH/X++ei7e5N4GmUoUH2RnYn
         yASXrqILAdomOIK8EJchtFDwzvVprSzSZKaE1VsUGrBLIbLBTRka0qqfFRrr4KIoU8Gj
         YK9b0JGvQ8sxUzeNFebMV40PB5pFTm1DjpOnzv//iqB7xypz10jjcw/Ld4aw0ren60Q/
         hgeg==
Content-Disposition: inline
In-Reply-To: <568AC534.1070308@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Ahern <dsa@cumulusnetworks.com>
Cc: netdev@vger.kernel.org, cgroups@vger.kernel.org, shm@cumulusnetworks.com, roopa@cumulusnetworks.com

Hello, David.

On Mon, Jan 04, 2016 at 12:17:08PM -0700, David Ahern wrote:
> None of the existing subsystems are relevant for configuring an L3
> networking domain, and it does not make sense to tie net_cls and net_prio to
> an L3 domain.

I don't have an answer for that but cgroup isn't a place to put such
stray configurations either.  Please figure out where the
configuration belongs first.  What you're proposing really isn't a
resource controller.  There's no resource being distributed
hierarchically.  It's just dumping configuration which hasn't found
its proper place into cgroup.

Thanks.

-- 
tejun
