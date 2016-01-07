From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv1 0/6] rdma controller support
Date: Thu, 7 Jan 2016 15:50:42 -0500
Message-ID: <20160107205042.GJ1898@mtj.duckdns.org>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
 <20160105215623.GH5995@mtj.duckdns.org>
 <CAG53R5XQaUz=vJCEqLwGt93CC1YMnVQ=k4DuRU0nspcb_-+_6g@mail.gmail.com>
 <20160107150718.GC29797@mtj.duckdns.org>
 <CAG53R5WwdRwb0XyAMGMey4JaDGUntJ9=m_ZToFkygboZxfMQ6A@mail.gmail.com>
 <20160107200604.GE1898@mtj.duckdns.org>
 <CAG53R5Xy8avVVvfGjgYOJSVRNFOHpiHXrQeEeb41EP4hy370QQ@mail.gmail.com>
 <20160107203425.GG1898@mtj.duckdns.org>
 <CAG53R5V80hY2SLrt3-GNeQ-wr+0aFM7sNJLvUGuy70t5dc8yOA@mail.gmail.com>
 <20160107204921.GI1898@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=yjr4CpKANoyigg9S47IU/lL/GHcnbSpWYOf0DdObN1w=;
        b=Yn/6VfkbrQRhSh7JP+Wa36gdh+PTfWNzTwqSjirh/oWEZMPFV6vXecc2TvCT0t5tjJ
         kUDXvGxTuVAJEXsztRkifdY5NubHrtHpdLd4Fpy4hyBCjVdDwzHbPo58m+GCHZ9v/cZO
         6vPNxydH7AxPxoIXehbFW4sdNJebsWVKs4S4Rv7yae/Gjg4fEqmgJr5pd52obod5wMKa
         Z02nH/ep12lA3RrxD0KQatm5a7ZWZ0W2pStPqKQhrtLvmCEYCUNCBxKatBdoyxNeNr6c
         qaFDcjTT04XazggFPUJPZ6lo2XWHHACCNCJ7TE67fuUrOBdQPLeSfAortl56oJdEYpdv
         CQZQ==
Content-Disposition: inline
In-Reply-To: <20160107204921.GI1898@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Ooh, btw, please don't bother to create separate interfaces for v1 and
v2 hierarchies.  Just creating one following v2 conventions and using
the same thing for v1 should do and is a lot easier for everybody.

Thanks.

-- 
tejun
