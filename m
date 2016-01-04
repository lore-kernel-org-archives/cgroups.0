From: David Ahern <dsa@cumulusnetworks.com>
Subject: Re: [RFC PATCH net-next] net: Add l3mdev cgroup
Date: Mon, 4 Jan 2016 12:59:15 -0700
Message-ID: <568ACF13.3030007@cumulusnetworks.com>
References: <1451925136-13327-1-git-send-email-dsa@cumulusnetworks.com>
 <20160104175836.GA11668@mtj.duckdns.org>
 <568ABFC3.3010803@cumulusnetworks.com>
 <20160104185936.GA3807@mtj.duckdns.org>
 <568AC534.1070308@cumulusnetworks.com>
 <20160104192301.GC3807@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-type:content-transfer-encoding;
        bh=o0VqFeeJi1vqNoUImtuBsYvadkmztlP6DoEatC+RnqY=;
        b=bkg1moZG7Ntn68cztPkSdMo5lxL9Ryhm5Aq8wSdXi58hPfGl8/MQD0OrKnVJ6fyaqg
         Ml7H89KNThkefUap58lei1HV4sTk+od1GwXW+OlBDqTFKvoAlCPMS4iqk9Sc05mdZFcZ
         BBkw8RJcG+Pv7eSFaTXd8PrSkzCm0C8SA8PrA=
In-Reply-To: <20160104192301.GC3807@mtj.duckdns.org>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: netdev@vger.kernel.org, cgroups@vger.kernel.org, shm@cumulusnetworks.com, roopa@cumulusnetworks.com

On 1/4/16 12:23 PM, Tejun Heo wrote:
> I don't have an answer for that but cgroup isn't a place to put such
> stray configurations either.  Please figure out where the
> configuration belongs first.  What you're proposing really isn't a
> resource controller.  There's no resource being distributed
> hierarchically.  It's just dumping configuration which hasn't found
> its proper place into cgroup.

cgroups have very nice properties that I want to leverage such as 
parent-child inheritance and easy tracking which subsystem instance a 
task belongs. This provides a great kernel foundation for building easy 
to use management tools.

The documentation for cgroups does not restrict a controller to physical 
resources but rather "it may be anything that wants to act on a group of 
processes." That is exactly what I am doing here - I have a network 
config that is applied to a group of processes similar to net_cls and 
net_prio (but as I stated before those are orthogonal, independent 
settings from the L3 domain).
