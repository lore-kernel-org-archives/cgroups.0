From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] cgroup: Update documentation reference
Date: Tue, 2 Jan 2018 07:00:42 -0800
Message-ID: <20180102150042.GB3668920@devbig577.frc2.facebook.com>
References: <20171229200200.18873-1-matthew.d.roper@intel.com>
 <20171229200200.18873-2-matthew.d.roper@intel.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+q5tb/zCK479yFzte/W/Pl2ilWOgMCwJTF7ibVoFfXA=;
        b=Yx/66tMw0PTi6kR5yt5s0fTt0RPmK2f25fK+VK4CnaCDDdoSLoy+Z2RLrJ2XZl716n
         m21fSPglYie/2TWAM+aqKlH1gI8QUd8XBSmf8VOT/8c/a3T/d7kExVwCdfOqReCixsHp
         3iiPpxjIvNB9F0qBCzMzB26WPPdYGW2UrxO9qHKPMWvGSo5U47KkBk6dSx5RwM+2rZf4
         vH1sthLY0yJ3Y+jZdU1BzfdMwwkgoqxDXShZr2GcjRdP3AbaLSr6AiJwe0ZKu+3KPIfQ
         lDH8pUnGE2I8dGPc2+GLsP6DbLf/U4iJbicR2pAgHEcaM1VrrOmCW4T9/IAdYZsPyTUU
         XuUg==
Content-Disposition: inline
In-Reply-To: <20171229200200.18873-2-matthew.d.roper@intel.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matt Roper <matthew.d.roper@intel.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Fri, Dec 29, 2017 at 12:02:00PM -0800, Matt Roper wrote:
> The cgroup_subsys structure references a documentation file that has been
> renamed after the v1/v2 split.  Since the v2 documentation doesn't
> currently contain any information on kernel interfaces for controllers,
> point the user to the v1 docs.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: linux-doc@vger.kernel.org
> Signed-off-by: Matt Roper <matthew.d.roper@intel.com>

Applied 1-2 to cgroup/for-4.16.

Thanks.

-- 
tejun
