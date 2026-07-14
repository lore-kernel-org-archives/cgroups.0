Received: from ns1.suksangroup.com (ns1.suksangroup.com [103.13.31.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE198309F1D
	for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 05:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.13.31.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784006195; cv=none; b=XpGT4G4wIIKKB6kmlFBcnh5mAHJbRwXdnzdG2xQXB+9S1kZ3ZKYlzr+Sjx6+KXv59vxXNrdZgC6P2qetvFjFvGN5cZvGH1ajCJwk3SoGylMq1fNkHJtVJf6PDb9Nt9qhx73NHOBlZJ5+he7jq4od55K2XxWpeLhMnjqzPyobFsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784006195; c=relaxed/simple;
	bh=bV0Crq7WEkjHVUrf6724K3hQI00bw/RYadNeVkAvTPM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=isiYa5NzKIu2EIOn2+/ctsYgHbrwcJffzY5Cjq4sncPK5eFBZQjyehMwfhprgWW97F7RL3RcfRPqpfRwJW/irExjp7X3B9R5bv8PoU6hiKMaT0wSsYi2U3ry+0hMTcxruo5eQ4P3smlcBFClIsHUE3TTPj4pkb+8lUVTIxzJcls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=inbox.org; spf=fail smtp.mailfrom=inbox.org; dkim=pass (2048-bit key) header.d=suksangroup.co.th header.i=@suksangroup.co.th header.b=v/kx4sph; arc=none smtp.client-ip=103.13.31.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=inbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=inbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suksangroup.co.th header.i=@suksangroup.co.th header.b="v/kx4sph"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=suksangroup.co.th; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:To:From:Reply-To:Sender:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=bV0Crq7WEkjHVUrf6724K3hQI00bw/RYadNeVkAvTPM=; b=v/kx4sph4oRVgyPHemkBHNNSKJ
	11hObeyZCvTUZM8H9ltb40oX++KNqjBXjhN+cq0ROaTGnfkXVHFgnEwoUCjDGpeKKBoYJZY5qrtfc
	N4S5jZKUJjIDXMWEbTCGohRofbbhA1xHBCSNWXU76nMmOeoRiFlYcsxECPfR/CK5vvSPMhIGF1/AF
	Uotghx5nRynwAyH43tlzZSeee1IHwrldbH/ihauejsHHL+ugdb29uhz+PgQPVVf/R+3lr1t4Irv3d
	0HBZIFbQ/arbX7Y0HCP3yoU6zfHOYja2PsQKncD3FJO7IsGSl0hQGrrI7YGccoT5L2r3cfk+9ud5H
	XwE3O1JA==;
Received: from [207.189.26.187] (port=60967)
	by ns1.suksangroup.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.4)
	(envelope-from <info@inbox.org>)
	id 1wjVVQ-0000000FrfE-2n7r
	for cgroups@vger.kernel.org;
	Tue, 14 Jul 2026 12:16:31 +0700
Reply-To: hanns.schofield@lexcapitalgrowth.com
From: Harry Schofield ESQ <info@inbox.org>
To: cgroups@vger.kernel.org
Subject: Dear cgroups, project info
Date: 14 Jul 2026 00:16:28 -0500
Message-ID: <20260714001628.E7EA577CE1494844@inbox.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ns1.suksangroup.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - inbox.org
X-Get-Message-Sender-Via: ns1.suksangroup.com: authenticated_id: smtp@suksangroup.co.th
X-Authenticated-Sender: ns1.suksangroup.com: smtp@suksangroup.co.th
X-Source: 
X-Source-Args: 
X-Source-Dir: 


Re:Good day cgroups,

Please let me know if this is best email to send you the project=20
info.

Kind regards,

Harry Schofield, ceMBA


