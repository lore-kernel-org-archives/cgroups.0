Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BA726E71E;
	Sun,  1 Feb 2026 16:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769964708; cv=none; b=VG0pcsikOUE8toq470uXgdZNKjsMzwC5AF4X0HrMc4917Wq3Bv5SgjG4ZzFkopxjTIjRQbc7Ai77giEDW3ZxZ3/vhThivRNvcEziDzVjCsDCoOvFmrVXprfU3P6O+xvIaiV1dFZWuw5wqO/CVYlzAXAkqpJdzX7pDJxey0rplw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769964708; c=relaxed/simple;
	bh=AvgjU4pq3tQBOXYv2Cm4Oz/DnPNOIpwzLhpGB43kziI=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=BvQBJhBUiKCn9Yuh1Zy9l4AhaQrz/2r53zgJAkEqaaLRLy0w4LKuyK0Kvr+jvpzlOLi7CxjVkYSOCBPCq/JtV4sb5gHBTSnx/wP5CE5U+Y6EHGaAgrDYuupGZP4TiA6G/YPeOfUh4OFkCz45/82VpVJSgkOunZwgemAKh+5h7PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z5TTiNl/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z5TTiNl/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10910C19425;
	Sun,  1 Feb 2026 16:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769964708;
	bh=AvgjU4pq3tQBOXYv2Cm4Oz/DnPNOIpwzLhpGB43kziI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Z5TTiNl/bNLMA7Ahq6drqGMN4cL2C8C50es4Iz+HqHuJCmQjo5OX9dMcrT3D5vJYv
	 f5LIDiUZlKpzzs52LgyAnpzwB8GiHSwTfSi39OVPklzulB6WuP3yxT6x0jtMp4C7d7
	 CXsk0of9nJ6v5uNrHDPgcaFrzpEZ6hxvGL2xMPimHB9wnci9CeuoFiUPCDlMRNRUR+
	 b27Dv+sBQYsiavj23wtql20vazo9nwdU6v5dgte+kYVrCpE7j/HBbwf0qZaBh0WXsq
	 xB4gvc0AAR6sC16XrPYlTlVeY4yKLwXzKaRqG5bLcsw1+l+sbON/SG8fOYjqiKyCNp
	 ypqrl85xsf/vQ==
Date: Sun, 01 Feb 2026 06:51:47 -1000
Message-ID: <3a1538ab6d0d1063dc49855cc5b303a8@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: longman@redhat.com, hannes@cmpxchg.org, mkoutny@suse.com,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 lujialin4@huawei.com
Subject: Re: [PATCH -next] cpuset: fix overlap of partition effective CPUs
In-Reply-To: <20260129064516.210203-1-chenridong@huaweicloud.com>
References: <20260129064516.210203-1-chenridong@huaweicloud.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-6.20.

Thanks.

-- 
tejun
