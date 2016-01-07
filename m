From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv1 0/6] rdma controller support
Date: Thu, 7 Jan 2016 15:34:25 -0500
Message-ID: <20160107203425.GG1898@mtj.duckdns.org>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
 <20160105215623.GH5995@mtj.duckdns.org>
 <CAG53R5XQaUz=vJCEqLwGt93CC1YMnVQ=k4DuRU0nspcb_-+_6g@mail.gmail.com>
 <20160107150718.GC29797@mtj.duckdns.org>
 <CAG53R5WwdRwb0XyAMGMey4JaDGUntJ9=m_ZToFkygboZxfMQ6A@mail.gmail.com>
 <20160107200604.GE1898@mtj.duckdns.org>
 <CAG53R5Xy8avVVvfGjgYOJSVRNFOHpiHXrQeEeb41EP4hy370QQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-security-module-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=wAozaDCfXsk/BzoMUn9crn20OuA3SQcuZUtsdog7th0=;
        b=rrdDA9lax5IXF8qwlCpDc4suSCpZZmLe9uKbFkzF2CGTm7ITvkaHKyftRn7wmuPEPX
         Djv4nn0Zn/XVMAzAK9IclH3od9Z81oTpF2bLnhMo7AVN4jX0jRCDUwX6CGlgqiGbb/P0
         /hg4tDv63u2rIl4GArbWsj3Ob+6Z0t4ypgBNLjA520oDsLgTw2zv5Tdp2Ww2ePxgYUJ4
         A2eGWq72TK2YZ9ZEKEMsoi27FOItswEFS1ERZ2RnRguC69XnLaJUuulBSI4WCqLlQUx8
         T5HGlLzI7er851nHdEc441Td8Oe6OptzKdxYJ5m+z9YoLClgJNnJuMtqD00Y7ewEIPqA
         TNtg==
Content-Disposition: inline
In-Reply-To: <CAG53R5Xy8avVVvfGjgYOJSVRNFOHpiHXrQeEeb41EP4hy370QQ@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Fri, Jan 08, 2016 at 02:02:20AM +0530, Parav Pandit wrote:
> o.k. That doable. I want to make sure that we are on same page on below design.
> rpool (which will contain static array based on header file ) would be
> still there, because resource limits are on per device basis. Number
> of devices are variable and dynamically appear. Therefore rdma_cg will
> have the list of rpool attached to it. Do you agree?

Yeap.  Would it make more sense to hang them off of whatever struct
which presents a rdma device tho?  And then just walk them from cgroup
controller?

Thanks.

-- 
tejun
